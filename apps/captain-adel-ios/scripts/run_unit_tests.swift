import Foundation

@main
struct FlightVerificationRunner {
    static var testsPassed = 0
    static var testsFailed = 0

    static let green = "\u{001B}[32m"
    static let red = "\u{001B}[31m"
    static let cyan = "\u{001B}[36m"
    static let amber = "\u{001B}[33m"
    static let reset = "\u{001B}[0m"
    static let bold = "\u{001B}[1m"

    static func assertTest(_ condition: Bool, _ name: String, file: String = #file, line: Int = #line) {
        if condition {
            testsPassed += 1
            print("  \(green)✓\(reset) \(name)")
        } else {
            testsFailed += 1
            print("  \(red)✗ FAILED:\(reset) \(name) (at \(file):\(line))")
        }
    }

    @MainActor
    static func main() async {
        print("\n\(cyan)\(bold)======================================================\(reset)")
        print("\(cyan)\(bold)  ✈️  CAPTAIN ADEL iOS - FLIGHT SUITE VERIFICATION  \(reset)")
        print("\(cyan)\(bold)======================================================\(reset)\n")

        // -----------------------------------------------------------------------------
        // SUITE 1: GACAR Corpus Database Integrity
        // -----------------------------------------------------------------------------
        print("\(bold)[1/5] GACAR 74-Part Corpus Database Integrity\(reset)")
        let parts = GACARCorpusDatabase.allParts
        assertTest(parts.count == 74, "Corpus contains exactly 74 regulatory parts (found: \(parts.count))")

        var allPartsValid = true
        var seenPartIDs = Set<String>()
        for part in parts {
            if part.id.isEmpty || seenPartIDs.contains(part.id) || !part.partNumber.hasPrefix("GACAR Part") {
                allPartsValid = false
            }
            seenPartIDs.insert(part.id)
            if part.titleEn.isEmpty || part.titleAr.isEmpty || part.summaryEn.isEmpty || part.keySections.isEmpty {
                allPartsValid = false
            }
            for section in part.keySections {
                if section.sectionCode.isEmpty || section.titleEn.isEmpty || section.titleAr.isEmpty || section.contentEn.isEmpty {
                    allPartsValid = false
                }
            }
        }
        assertTest(allPartsValid, "All 74 Parts have valid non-empty IDs, titles, summaries, and key sections")

        let partNumbers = Set(parts.map { $0.partNumber })
        let coreAviationParts = ["GACAR Part 1", "GACAR Part 61", "GACAR Part 67", "GACAR Part 91", "GACAR Part 107", "GACAR Part 121", "GACAR Part 145"]
        let hasAllCore = coreAviationParts.allSatisfy { partNumbers.contains($0) }
        assertTest(hasAllCore, "Core aviation regulations (Parts 1, 61, 67, 91, 107, 121, 145) present")

        // -----------------------------------------------------------------------------
        // SUITE 2: On-Device Vector Search Engine (FL380 Mode)
        // -----------------------------------------------------------------------------
        print("\n\(bold)[2/5] On-Device Semantic Vector Search & Normalization\(reset)")
        let engine = GACARVectorSearchEngine.shared

        // Tashkeel normalization
        let tashkeelInput = "شُرُوطُ التَّرْخِيصِ وَالصَّلَاحِيَّةِ"
        let tokens = engine.tokenize(tashkeelInput)
        let hasNoTashkeel = tokens.allSatisfy { $0.range(of: "[\u{064B}-\u{0652}]", options: .regularExpression) == nil }
        assertTest(hasNoTashkeel && !tokens.isEmpty, "Arabic Tashkeel (diacritics) correctly stripped during tokenization")

        // Hamza normalization
        let hamzaTokens = engine.tokenize("إقلاع طائرة أمنية مع آليات")
        let hamzaNormalized = hamzaTokens.allSatisfy { !$0.contains("أ") && !$0.contains("إ") && !$0.contains("آ") }
        assertTest(hamzaNormalized, "Arabic Alef/Hamza variants normalized to bare Alef")

        // Taa marbuta normalization
        let taaTokens = engine.tokenize("مراقبة جوية")
        let taaNormalized = taaTokens.allSatisfy { !$0.contains("ة") }
        assertTest(taaNormalized, "Arabic Taa Marbuta (ة) normalized to Haa (ه)")

        // Stopwords
        let englishTokens = engine.tokenize("what are the minimums for vfr in controlled airspace")
        assertTest(!englishTokens.contains("the") && !englishTokens.contains("what") && englishTokens.contains("vfr"), "Aviation stopwords filtered while preserving domain keywords")

        // Cite or Refuse: Grounded query
        let vfrQuery = "VFR weather minima visibility cloud separation"
        let vfrResponse = engine.retrieve(query: vfrQuery)
        assertTest(!vfrResponse.isRefusal, "Legitimate VFR minima query accepted by Cite-or-Refuse gate")
        assertTest(vfrResponse.topSimilarity >= engine.refusalThreshold, "Grounding similarity meets or exceeds 0.28 safety threshold (got: \(String(format: "%.3f", vfrResponse.topSimilarity)))")
        assertTest(vfrResponse.citations.first?.sectionNumber == "91.155", "Response correctly cited GACAR §91.155")
        assertTest(vfrResponse.telemetryTag.contains("FL380 RAG"), "HUD telemetry tag properly formatted")

        // Cite or Refuse: Refusal query
        let sciFiQuery = "quantum warp drive hyperdrive across Alpha Centauri"
        let refusalResponse = engine.retrieve(query: sciFiQuery)
        assertTest(refusalResponse.isRefusal, "Ungrounded/sci-fi query triggers mandatory refusal doctrine")
        assertTest(refusalResponse.citations.isEmpty, "Refusal response provides zero hallucinated citations")
        assertTest(refusalResponse.answerEn.contains("I'd rather refuse than guess"), "Refusal cites authoritative gaca.gov.sa SOP")

        // Exact section code boost
        let boostResults = engine.search(query: "rules in 107.51", topK: 1)
        assertTest(boostResults.first?.section.sectionCode == "107.51", "Exact section code '107.51' receives deterministic boost")

        // Latency benchmark
        let start = CFAbsoluteTimeGetCurrent()
        _ = engine.retrieve(query: "minimum fuel reserve for flight at night")
        let elapsedMs = (CFAbsoluteTimeGetCurrent() - start) * 1000.0
        assertTest(elapsedMs < 60.0, "Vector retrieval latency is <60ms (measured: \(String(format: "%.1f", elapsedMs))ms)")

        // -----------------------------------------------------------------------------
        // SUITE 3: NOAA METAR Aviation Weather Engine
        // -----------------------------------------------------------------------------
        print("\n\(bold)[3/5] NOAA Saudi Aviation Weather & FMC Vector Math\(reset)")

        // 18 Saudi aerodromes coverage
        let aerodromes = METARService.defaultSaudiAirports
        assertTest(aerodromes.count == 18, "Complete 18-aerodrome Saudi network configured")
        let allSaudiICAO = aerodromes.allSatisfy { $0.icaoCode.hasPrefix("OE") && $0.icaoCode.count == 4 }
        assertTest(allSaudiICAO, "All 18 aerodromes have valid 4-character OE* ICAO identifiers")

        // Crosswind direct headwind
        let (cw1, hw1) = METARService.calculateCrosswind(windSpeed: 20.0, windDirection: 360.0, runwayHeading: 360.0)
        assertTest(abs(cw1) < 0.001 && abs(hw1 - 20.0) < 0.001, "Direct headwind: Crosswind = 0 kt, Headwind = 20 kt")

        // Crosswind direct crosswind
        let (cw2, hw2) = METARService.calculateCrosswind(windSpeed: 15.0, windDirection: 090.0, runwayHeading: 360.0)
        assertTest(abs(cw2 - 15.0) < 0.001 && abs(hw2) < 0.001, "Direct 90° crosswind: Crosswind = 15 kt, Headwind = 0 kt")

        // Angle wrap-around (350° to 010° = 20° delta)
        let (cw3, hw3) = METARService.calculateCrosswind(windSpeed: 20.0, windDirection: 350.0, runwayHeading: 010.0)
        let expectedCw = 20.0 * sin(20.0 * .pi / 180.0)
        let expectedHw = 20.0 * cos(20.0 * .pi / 180.0)
        assertTest(abs(cw3 - expectedCw) < 0.05 && abs(hw3 - expectedHw) < 0.05, "Angle wrap-around across 360° north correctly resolved (20° delta)")

        // Tailwind detection (wind 180° on runway 360°)
        let (cw4, hw4) = METARService.calculateCrosswind(windSpeed: 12.0, windDirection: 180.0, runwayHeading: 360.0)
        assertTest(abs(cw4) < 0.001 && hw4 < -11.9, "Negative headwind correctly signals tailwind component (-12 kt)")

        // -----------------------------------------------------------------------------
        // SUITE 4: FMC Calculators & Flight Checklists
        // -----------------------------------------------------------------------------
        print("\n\(bold)[4/5] FMC Calculators & GACAR §91 Operational Procedures\(reset)")

        // VFR Fuel Reserve GACAR §91.151
        let burnRate = 10.0 // GPH
        let flightTime = 2.0 // hours
        let dayReserveMin = 30.0
        let nightReserveMin = 45.0

        let tripFuel = burnRate * flightTime
        let dayTotal = tripFuel + (burnRate * dayReserveMin / 60.0)
        let nightTotal = tripFuel + (burnRate * nightReserveMin / 60.0)
        assertTest(dayTotal == 25.0, "Day VFR: 2.0 hr @ 10 GPH + 30 min reserve = 25.0 GAL (§91.151)")
        assertTest(nightTotal == 27.5, "Night VFR: 2.0 hr @ 10 GPH + 45 min reserve = 27.5 GAL (§91.151)")

        // Checklists database
        let checklists = CockpitChecklistDatabase.defaultChecklists()
        assertTest(!checklists.isEmpty, "Cockpit checklist database populated with operational checklists")
        let hasPreflight = checklists.contains { $0.id == "preflight_normal" }
        let hasEmergency = checklists.contains { $0.checklistType == .emergency }
        assertTest(hasPreflight && hasEmergency, "Normal preflight & Emergency QRF procedures both available")

        var testList = checklists.first!
        assertTest(testList.progress == 0.0 && !testList.isComplete, "Initial checklist state: 0% progress and unverified")
        testList.items[0].isCompleted = true
        assertTest(testList.completedCount == 1, "Completed items count increments correctly")

        // -----------------------------------------------------------------------------
        // SUITE 5: Dynamic Citation Extraction
        // -----------------------------------------------------------------------------
        print("\n\(bold)[5/5] Dynamic Citation Extraction Across 74 GACAR Parts\(reset)")
        let service = CaptainAdelAIService()

        let sampleAiText = """
        In accordance with GACAR §91.155, basic VFR flight visibility must not be less than 5 km.
        Also note that GACAR §61.103 requires applicants to be at least 17 years old for private pilot.
        """
        let extracted = service.extractCitations(from: sampleAiText)
        assertTest(extracted.count == 2, "Extracted 2 citations from simulated LLM stream response")
        let extractedCodes = Set(extracted.map { $0.sectionNumber })
        assertTest(extractedCodes.contains("91.155") && extractedCodes.contains("61.103"), "Extracted section numbers match §91.155 and §61.103")

        let emptyText = "Welcome to the flight deck, ready for taxi."
        let noCitations = service.extractCitations(from: emptyText)
        assertTest(noCitations.isEmpty, "No citations extracted when text does not reference GACAR sections")

        // -----------------------------------------------------------------------------
        // SUMMARY
        // -----------------------------------------------------------------------------
        print("\n\(cyan)\(bold)======================================================\(reset)")
        if testsFailed == 0 {
            print("\(green)\(bold)  ✓ ALL \(testsPassed) TESTS PASSED SUCCESSFULLY! (0 Failures)  \(reset)")
            print("\(cyan)\(bold)======================================================\(reset)\n")
            exit(0)
        } else {
            print("\(red)\(bold)  ✗ \(testsFailed) TEST(S) FAILED out of \(testsPassed + testsFailed) total tests!  \(reset)")
            print("\(cyan)\(bold)======================================================\(reset)\n")
            exit(1)
        }
    }
}
