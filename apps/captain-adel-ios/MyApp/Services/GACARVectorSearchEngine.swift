import Foundation

struct VectorSearchResult {
    let section: GACARSection
    let part: GACARPart
    let similarity: Double
    let matchedTerms: [String]
}

struct GACARRetrievalResponse {
    let isRefusal: Bool
    let answerEn: String
    let answerAr: String
    let citations: [GACARCitation]
    let topSimilarity: Double
    let latencyMs: Int
    let telemetryTag: String
}

/// On-Device Semantic Vector Retrieval Engine (TF-IDF & Cosine Similarity) for FL380 Flight Mode
final class GACARVectorSearchEngine {
    static let shared = GACARVectorSearchEngine()
    
    // Inverted index & precomputed document vectors
    private var documentVectors: [String: [String: Double]] = [:] // sectionId -> [term: weight]
    private var documentNorms: [String: Double] = [:] // sectionId -> norm
    private var sectionLookup: [String: (section: GACARSection, part: GACARPart)] = [:]
    private var idfWeights: [String: Double] = [:]
    
    let refusalThreshold: Double = 0.28
    
    private init() {
        buildIndex()
    }
    
    private func buildIndex() {
        var docFreqs: [String: Int] = [:]
        let parts = GACARCorpusDatabase.allParts
        var totalDocuments = 0
        
        // 1. Gather all documents (sections)
        var tokenizedDocs: [String: [String]] = [:]
        
        for part in parts {
            for section in part.keySections {
                let docId = section.sectionCode
                sectionLookup[docId] = (section, part)
                
                let corpusText = """
                \(part.partNumber) \(part.titleEn) \(part.titleAr) \(part.summaryEn) \(part.summaryAr)
                \(section.sectionCode) \(section.titleEn) \(section.titleAr) \(section.contentEn) \(section.contentAr)
                """
                let tokens = tokenize(corpusText)
                tokenizedDocs[docId] = tokens
                totalDocuments += 1
                
                let uniqueTokens = Set(tokens)
                for token in uniqueTokens {
                    docFreqs[token, default: 0] += 1
                }
            }
        }
        
        // 2. Compute IDF: log((N + 1) / (df + 1)) + 1
        for (token, df) in docFreqs {
            idfWeights[token] = log(Double(totalDocuments + 1) / Double(df + 1)) + 1.0
        }
        
        // 3. Compute TF-IDF document vectors and Euclidean norms
        for (docId, tokens) in tokenizedDocs {
            var tf: [String: Double] = [:]
            for token in tokens {
                tf[token, default: 0] += 1.0
            }
            
            var vector: [String: Double] = [:]
            var sumSquared: Double = 0.0
            
            for (token, count) in tf {
                let idf = idfWeights[token] ?? 1.0
                let tfWeight = 1.0 + log(count)
                let weight = tfWeight * idf
                vector[token] = weight
                sumSquared += weight * weight
            }
            
            documentVectors[docId] = vector
            documentNorms[docId] = max(0.0001, sqrt(sumSquared))
        }
    }
    
    // Bilingual Tokenizer & Text Normalizer
    func tokenize(_ text: String) -> [String] {
        var normalized = text.lowercased()
        
        // Arabic Normalization: strip diacritics & standardise characters
        normalized = normalized
            .replacingOccurrences(of: "[\u{064B}-\u{0652}]", with: "", options: .regularExpression) // Tashkeel
            .replacingOccurrences(of: "[أإآ]", with: "ا", options: .regularExpression)
            .replacingOccurrences(of: "ى", with: "ي")
            .replacingOccurrences(of: "ة", with: "ه")
            .replacingOccurrences(of: "§", with: "")
        
        // Tokenize by word boundary
        let separators = CharacterSet.alphanumerics.inverted
        let rawTokens = normalized.components(separatedBy: separators).filter { !$0.isEmpty }
        
        let stopWords: Set<String> = [
            "the", "is", "at", "which", "on", "and", "a", "an", "in", "to", "for", "of", "or", "what", "are", "how", "can",
            "في", "من", "على", "هل", "ما", "هو", "هي", "عن", "مع", "الى", "او", "ان", "تم", "قد", "كل", "كم"
        ]
        
        return rawTokens.filter { !stopWords.contains($0) && $0.count > 1 }
    }
    
    // Semantic Vector Search Execution
    func search(query: String, topK: Int = 3) -> [VectorSearchResult] {
        let queryTokens = tokenize(query)
        guard !queryTokens.isEmpty else { return [] }
        
        // Build Query Vector
        var queryTF: [String: Double] = [:]
        for token in queryTokens {
            queryTF[token, default: 0] += 1.0
        }
        
        var queryVector: [String: Double] = [:]
        var querySumSquared: Double = 0.0
        
        for (token, count) in queryTF {
            let idf = idfWeights[token] ?? 1.0
            let weight = (1.0 + log(count)) * idf
            queryVector[token] = weight
            querySumSquared += weight * weight
        }
        
        let queryNorm = max(0.0001, sqrt(querySumSquared))
        
        var results: [VectorSearchResult] = []
        
        for (docId, docVector) in documentVectors {
            guard let docNorm = documentNorms[docId],
                  let entry = sectionLookup[docId] else { continue }
            
            var dotProduct: Double = 0.0
            var matched: [String] = []
            
            for (token, qWeight) in queryVector {
                if let dWeight = docVector[token] {
                    dotProduct += qWeight * dWeight
                    matched.append(token)
                }
            }
            
            var cosineSimilarity = dotProduct / (queryNorm * docNorm)
            
            // Section Code Exact Boost (e.g. query contains "91.155" or "107.51")
            let rawQuery = query.replacingOccurrences(of: "§", with: "")
            if rawQuery.contains(entry.section.sectionCode) || rawQuery.contains(entry.part.id) {
                cosineSimilarity = min(1.0, cosineSimilarity + 0.35)
            }
            
            if cosineSimilarity > 0.05 {
                results.append(VectorSearchResult(
                    section: entry.section,
                    part: entry.part,
                    similarity: cosineSimilarity,
                    matchedTerms: matched
                ))
            }
        }
        
        results.sort { $0.similarity > $1.similarity }
        return Array(results.prefix(topK))
    }
    
    // Complete Grounding & Refusal Pipeline
    func retrieve(query: String) -> GACARRetrievalResponse {
        let startTime = CFAbsoluteTimeGetCurrent()
        let topResults = search(query: query, topK: 3)
        let elapsedMs = max(1, Int((CFAbsoluteTimeGetCurrent() - startTime) * 1000))
        
        guard let best = topResults.first, best.similarity >= refusalThreshold else {
            // REFUSAL DOCTRINE TRIGGERED
            let refusalEn = """
            I can't ground that in the GACAR corpus. I'd rather refuse than guess — the authoritative source is always GACA at gaca.gov.sa.
            """
            let refusalAr = """
            لا يمكنني إسناد ذلك في نصوص لوائح GACAR. أفضّل الاعتذار على التخمين — المرجع الرسمي دائماً هو الهيئة العامة للطيران المدني على gaca.gov.sa.
            """
            
            return GACARRetrievalResponse(
                isRefusal: true,
                answerEn: refusalEn,
                answerAr: refusalAr,
                citations: [],
                topSimilarity: topResults.first?.similarity ?? 0.0,
                latencyMs: elapsedMs,
                telemetryTag: "FL380 RAG · REFUSAL // NO CORPUS MATCH · \(elapsedMs)ms"
            )
        }
        
        // GROUNDED RESPONSE SYNTHESIS
        let section = best.section
        let part = best.part
        let confidencePct = Int(best.similarity * 100)
        
        let answerEn = """
        Under **\(part.partNumber) §\(section.sectionCode)** (*\(section.titleEn)*):
        
        \(section.contentEn)
        
        *Operational Guidance:* This requirement is codified under Saudi Civil Aviation Regulations for \(part.category.rawValue).
        """
        
        let answerAr = """
        بموجب المادة **\(part.partNumber) §\(section.sectionCode)** (*\(section.titleAr)*):
        
        \(section.contentAr)
        
        *التطبيق التشغيلي:* هذا الحكم ملزم ومعتمد نظاماً في لوائح الطيران المدني السعودي ضمن تصنيف \(part.category.arabicName).
        """
        
        let citation = GACARCitation(
            partNumber: part.partNumber,
            title: section.titleEn,
            arabicTitle: section.titleAr,
            sectionNumber: section.sectionCode,
            verbatimSnippet: "\(part.partNumber) §\(section.sectionCode): \(section.contentEn)",
            arabicVerbatimSnippet: "\(part.partNumber) §\(section.sectionCode): \(section.contentAr)",
            category: part.category
        )
        
        let tag = "FL380 RAG · §\(section.sectionCode) · \(confidencePct)% MATCH · \(elapsedMs)ms"
        
        return GACARRetrievalResponse(
            isRefusal: false,
            answerEn: answerEn,
            answerAr: answerAr,
            citations: [citation],
            topSimilarity: best.similarity,
            latencyMs: elapsedMs,
            telemetryTag: tag
        )
    }
}
