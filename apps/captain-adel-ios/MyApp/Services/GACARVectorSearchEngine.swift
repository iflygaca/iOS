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

/// Compact Int8 Quantized Vector for Ultra-Low Memory Cockpit RAG
struct QuantizedDocumentVector {
    let scale: Float // Dequantization factor
    let weights: [String: Int8] // 8-bit quantized weights (-127...127)
    let norm: Float
    let docLength: Int
}

/// High-Performance Offline & On-Device RAG Engine for Disconnected FL380 Flight Decks
/// Implements Int8 Quantization, BM25 Length Normalization, and Arabic Morphology
final class GACARVectorSearchEngine {
    static let shared = GACARVectorSearchEngine()

    // Quantized Inverted Index & Document Lookups
    private var quantizedVectors: [String: QuantizedDocumentVector] = [:] // sectionId -> quantized vector
    private var sectionLookup: [String: (section: GACARSection, part: GACARPart)] = [:]
    private var idfWeights: [String: Double] = [:]
    private var avgDocLength: Double = 50.0

    // High-speed L1 Retrieval Cache for Instant Cockpit Lookups
    private var responseCache: [String: GACARRetrievalResponse] = [:]
    private let cacheLock = NSLock()

    let refusalThreshold: Double = 0.28
    private let bm25K1: Double = 1.2
    private let bm25B: Double = 0.75

    private init() {
        buildIndex()
    }

    private func buildIndex() {
        var docFreqs: [String: Int] = [:]
        let parts = GACARCorpusDatabase.allParts
        var totalDocuments = 0
        var totalTokens = 0

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
                totalTokens += tokens.count

                let uniqueTokens = Set(tokens)
                for token in uniqueTokens {
                    docFreqs[token, default: 0] += 1
                }
            }
        }

        avgDocLength = totalDocuments > 0 ? Double(totalTokens) / Double(totalDocuments) : 50.0

        // 2. Compute BM25 / Smooth IDF: log((N - n + 0.5) / (n + 0.5) + 1.0)
        for (token, df) in docFreqs {
            let n = Double(df)
            let N = Double(totalDocuments)
            let idf = log((N - n + 0.5) / (n + 0.5) + 1.0)
            idfWeights[token] = max(0.2, idf)
        }

        // 3. Compute Quantized Int8 Vectors with BM25 Saturation
        for (docId, tokens) in tokenizedDocs {
            let docLen = tokens.count
            var tf: [String: Double] = [:]
            for token in tokens {
                tf[token, default: 0] += 1.0
            }

            var unquantized: [String: Float] = [:]
            var maxVal: Float = 0.0001

            for (token, count) in tf {
                let idf = idfWeights[token] ?? 1.0
                // BM25 term weighting with length normalization
                let numerator = count * (bm25K1 + 1.0)
                let denominator = count + bm25K1 * (1.0 - bm25B + bm25B * (Double(docLen) / avgDocLength))
                let bm25Weight = Float(idf * (numerator / denominator))
                unquantized[token] = bm25Weight
                if bm25Weight > maxVal {
                    maxVal = bm25Weight
                }
            }

            // Quantize to Int8: value / maxVal * 127.0
            let scale = maxVal / 127.0
            var int8Weights: [String: Int8] = [:]
            var sumSquared: Float = 0.0

            for (token, val) in unquantized {
                let quantized = Int8(clamping: Int(round(val / scale)))
                int8Weights[token] = quantized
                sumSquared += val * val
            }

            let docNorm = max(0.001, sqrt(sumSquared))
            quantizedVectors[docId] = QuantizedDocumentVector(
                scale: scale,
                weights: int8Weights,
                norm: docNorm,
                docLength: docLen
            )
        }
    }

    // Bilingual Tokenizer & Text Normalizer
    func tokenize(_ text: String) -> [String] {
        var normalized = text.lowercased()

        // Arabic Normalization: strip diacritics & standardise characters
        normalized = normalized
            .replacingOccurrences(of: "[\\u{064B}-\\u{0652}]", with: "", options: .regularExpression) // Tashkeel
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

    // High-Performance Quantized Vector Search Execution
    func search(query: String, topK: Int = 3) -> [VectorSearchResult] {
        let queryTokens = tokenize(query)
        guard !queryTokens.isEmpty else { return [] }

        // Build Query Vector with BM25 TF-IDF
        var queryTF: [String: Double] = [:]
        for token in queryTokens {
            queryTF[token, default: 0] += 1.0
        }

        var queryVector: [String: Float] = [:]
        var querySumSquared: Float = 0.0

        for (token, count) in queryTF {
            let idf = Float(idfWeights[token] ?? 1.0)
            let weight = Float(1.0 + log(count)) * idf
            queryVector[token] = weight
            querySumSquared += weight * weight
        }

        let queryNorm = max(0.0001, sqrt(querySumSquared))
        var results: [VectorSearchResult] = []

        for (docId, qDoc) in quantizedVectors {
            guard let entry = sectionLookup[docId] else { continue }

            var dotProduct: Float = 0.0
            var matched: [String] = []

            for (token, qWeight) in queryVector {
                if let int8Val = qDoc.weights[token] {
                    // Dequantize on-the-fly: Int8 * scale
                    let dequantized = Float(int8Val) * qDoc.scale
                    dotProduct += qWeight * dequantized
                    matched.append(token)
                }
            }

            var cosineSimilarity = Double(dotProduct / (queryNorm * qDoc.norm))

            // Section Code Exact Boost (e.g. query contains "91.155", "107.29", "121.619")
            let rawQuery = query.replacingOccurrences(of: "§", with: "").lowercased()
            if rawQuery.contains(entry.section.sectionCode.lowercased()) || rawQuery.contains(entry.part.id) {
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

    // Complete Grounding & Refusal Pipeline with Int8 Quantized RAG Telemetry
    func retrieve(query: String) -> GACARRetrievalResponse {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        cacheLock.lock()
        if let cached = responseCache[trimmed] {
            cacheLock.unlock()
            return cached
        }
        cacheLock.unlock()

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

            let response = GACARRetrievalResponse(
                isRefusal: true,
                answerEn: refusalEn,
                answerAr: refusalAr,
                citations: [],
                topSimilarity: topResults.first?.similarity ?? 0.0,
                latencyMs: elapsedMs,
                telemetryTag: "FL380 QUANTIZED RAG (Int8) · REFUSAL // NO CORPUS MATCH · \(elapsedMs)ms"
            )

            cacheLock.lock()
            responseCache[trimmed] = response
            cacheLock.unlock()
            return response
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

        let tag = "FL380 QUANTIZED RAG (Int8) · §\(section.sectionCode) · \(confidencePct)% MATCH · \(elapsedMs)ms"

        let response = GACARRetrievalResponse(
            isRefusal: false,
            answerEn: answerEn,
            answerAr: answerAr,
            citations: [citation],
            topSimilarity: best.similarity,
            latencyMs: elapsedMs,
            telemetryTag: tag
        )

        cacheLock.lock()
        responseCache[trimmed] = response
        cacheLock.unlock()
        return response
    }
}
