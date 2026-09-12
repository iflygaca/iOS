import XCTest
@testable import MyApp

final class GACARVectorSearchEngineTests: XCTestCase {
    var engine: GACARVectorSearchEngine!

    override func setUp() {
        super.setUp()
        engine = GACARVectorSearchEngine.shared
    }

    // MARK: - Tokenizer & Arabic Normalization Tests

    func testTokenizerArabicTashkeelRemoval() {
        let textWithTashkeel = "شُرُوطُ التَّرْخِيصِ وَالصَّلَاحِيَّةِ"
        let tokens = engine.tokenize(textWithTashkeel)
        
        // Tashkeel must be removed and words tokenized
        XCTAssertFalse(tokens.isEmpty, "Tokens should not be empty")
        for token in tokens {
            let containsTashkeel = token.range(of: "[\u{064B}-\u{0652}]", options: .regularExpression) != nil
            XCTAssertFalse(containsTashkeel, "Token '\(token)' should not contain Arabic tashkeel")
        }
    }

    func testTokenizerArabicAlefHamzaNormalization() {
        let input = "إقلاع طائرة أمنية مع آليات"
        let tokens = engine.tokenize(input)
        
        // أ, إ, آ should be normalized to ا
        for token in tokens {
            XCTAssertFalse(token.contains("أ"), "Alef with hamza above should be normalized")
            XCTAssertFalse(token.contains("إ"), "Alef with hamza below should be normalized")
            XCTAssertFalse(token.contains("آ"), "Alef with madda should be normalized")
        }
    }

    func testTokenizerArabicTaaMarbutaNormalization() {
        let input = "مراقبة جوية"
        let tokens = engine.tokenize(input)
        
        // ة should be normalized to ه
        for token in tokens {
            XCTAssertFalse(token.contains("ة"), "Taa marbuta should be normalized to haa")
        }
    }

    func testTokenizerAviationStopwordsRemoved() {
        let input = "what are the minimums for vfr in controlled airspace"
        let tokens = engine.tokenize(input)
        
        XCTAssertFalse(tokens.contains("the"), "Stopword 'the' should be excluded")
        XCTAssertFalse(tokens.contains("what"), "Stopword 'what' should be excluded")
        XCTAssertFalse(tokens.contains("are"), "Stopword 'are' should be excluded")
        XCTAssertFalse(tokens.contains("in"), "Stopword 'in' should be excluded")
        XCTAssertTrue(tokens.contains("vfr"), "Aviation keyword 'vfr' should be kept")
        XCTAssertTrue(tokens.contains("airspace"), "Keyword 'airspace' should be kept")
    }

    // MARK: - Cite or Refuse Doctrine Tests

    func testRefusalDoctrineTriggeredOnSciFiQuery() {
        let sciFiQuery = "quantum warp drive hyperdrive speeds across Alpha Centauri"
        let response = engine.retrieve(query: sciFiQuery)
        
        XCTAssertTrue(response.isRefusal, "Sci-fi query should trigger refusal doctrine")
        XCTAssertTrue(response.citations.isEmpty, "Refusal response should contain no citations")
        XCTAssertTrue(response.answerEn.contains("I'd rather refuse than guess"), "Should contain authoritative refusal")
        XCTAssertTrue(response.answerAr.contains("أفضّل الاعتذار على التخمين"), "Should contain Arabic refusal")
        XCTAssertTrue(response.telemetryTag.contains("REFUSAL"), "Telemetry tag should record refusal")
    }

    func testGroundedRetrievalForVFRMinima() {
        let query = "VFR weather minima visibility cloud separation"
        let response = engine.retrieve(query: query)
        
        XCTAssertFalse(response.isRefusal, "VFR weather query should be grounded in GACAR")
        XCTAssertGreaterThanOrEqual(response.topSimilarity, engine.refusalThreshold, "Score must meet refusal threshold")
        XCTAssertFalse(response.citations.isEmpty, "Grounded response must have at least one citation")
        
        let firstCitation = response.citations.first!
        XCTAssertEqual(firstCitation.partNumber, "GACAR Part 91")
        XCTAssertEqual(firstCitation.sectionNumber, "91.155")
        XCTAssertTrue(response.telemetryTag.contains("FL380 RAG"))
    }

    func testExactSectionCodeBoost() {
        let queryWithSection = "requirements under 107.51"
        let results = engine.search(query: queryWithSection, topK: 1)
        
        XCTAssertFalse(results.isEmpty, "Search should return result")
        XCTAssertEqual(results.first?.section.sectionCode, "107.51", "Exact section code should be top match")
        XCTAssertGreaterThanOrEqual(results.first!.similarity, 0.35, "Exact match boost should elevate similarity")
    }

    func testRetrievalPerformanceUnderFlightHUDLatencyLimit() {
        let query = "Fuel requirements for night VFR flight"
        let start = CFAbsoluteTimeGetCurrent()
        let response = engine.retrieve(query: query)
        let elapsedMs = (CFAbsoluteTimeGetCurrent() - start) * 1000.0
        
        XCTAssertLessThan(elapsedMs, 60.0, "On-device retrieval must complete under 60ms for cockpit responsiveness")
        XCTAssertFalse(response.isRefusal, "Night fuel query should be grounded in Part 91")
    }
}
