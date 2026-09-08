import SwiftUI

// MARK: - App Language
enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case arabic = "ar"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .english: return "English"
        case .arabic: return "العربية"
        }
    }

    var flagEmoji: String {
        switch self {
        case .english: return "🇬🇧"
        case .arabic: return "🇸🇦"
        }
    }

    var isRTL: Bool {
        self == .arabic
    }
}

// MARK: - Chat Message
struct ChatMessage: Identifiable, Equatable {
    let id: UUID
    let sender: MessageSender
    var text: String
    var arabicText: String?
    let timestamp: Date
    var citations: [GACARCitation]
    var isStreaming: Bool

    init(
        id: UUID = UUID(),
        sender: MessageSender,
        text: String,
        arabicText: String? = nil,
        timestamp: Date = Date(),
        citations: [GACARCitation] = [],
        isStreaming: Bool = false
    ) {
        self.id = id
        self.sender = sender
        self.text = text
        self.arabicText = arabicText
        self.timestamp = timestamp
        self.citations = citations
        self.isStreaming = isStreaming
    }
}

enum MessageSender: Equatable {
    case user
    case captainAdel
}

// MARK: - GACAR Regulation & Citation
struct GACARCitation: Identifiable, Equatable, Hashable {
    var id: String { partNumber + (sectionNumber ?? "") }
    let partNumber: String // e.g. "Part 61"
    let title: String
    let arabicTitle: String
    let sectionNumber: String? // e.g. "61.103"
    let verbatimSnippet: String
    let arabicVerbatimSnippet: String
    let category: GACARCategory
}

enum GACARCategory: String, CaseIterable, Identifiable {
    case licensing = "Licensing & Certification"
    case operations = "Flight Operations"
    case medical = "Medical Standards"
    case uas = "Drones / UAS"
    case maintenance = "Airworthiness & Maintenance"
    case airports = "Airports & Airspace"

    var id: String { rawValue }

    var arabicName: String {
        switch self {
        case .licensing: return "التراخيص والشهادات"
        case .operations: return "عمليات الطيران"
        case .medical: return "المعايير الطبية"
        case .uas: return "الطائرات بدون طيار (UAS)"
        case .maintenance: return "الصلاحية والصيانة"
        case .airports: return "المطارات والمجال الجوي"
        }
    }

    var iconName: String {
        switch self {
        case .licensing: return "person.badge.shield.checkmark.fill"
        case .operations: return "airplane"
        case .medical: return "heart.text.square.fill"
        case .uas: return "circle.hexagonpath.fill"
        case .maintenance: return "wrench.and.screwdriver.fill"
        case .airports: return "building.columns.fill"
        }
    }
}

struct GACARPart: Identifiable, Hashable {
    let id: String // e.g. "61"
    let partNumber: String // e.g. "GACAR Part 61"
    let titleEn: String
    let titleAr: String
    let category: GACARCategory
    let summaryEn: String
    let summaryAr: String
    let keySections: [GACARSection]
}

struct GACARSection: Identifiable, Hashable {
    var id: String { sectionCode }
    let sectionCode: String // e.g. "61.103"
    let titleEn: String
    let titleAr: String
    let contentEn: String
    let contentAr: String
}

// MARK: - Exam Prep Quiz & Flashcard
struct QuizQuestion: Identifiable {
    let id = UUID()
    let category: GACARCategory
    let questionEn: String
    let questionAr: String
    let optionsEn: [String]
    let optionsAr: [String]
    let correctOptionIndex: Int
    let gacarReference: String
    let explanationEn: String
    let explanationAr: String
}

// MARK: - METAR Aviation Weather Model
struct METARReport: Identifiable {
    let id = UUID()
    let rawText: String
    let icaoCode: String
    let airportNameEn: String
    let airportNameAr: String
    let flightCategory: FlightCategory
    let windInfo: String
    let visibility: String
    let ceiling: String
    let temperature: String
    let dewPoint: String
    let altimeter: String
    let remarks: String
}

enum FlightCategory: String {
    case vfr = "VFR"
    case mvfr = "MVFR"
    case ifr = "IFR"

    var color: Color {
        switch self {
        case .vfr: return .green
        case .mvfr: return .blue
        case .ifr: return .red
        }
    }

    var arabicDescription: String {
        switch self {
        case .vfr: return "قواعد الطيران البصري (ممتاز)"
        case .mvfr: return "قواعد طيران بصري هامشية"
        case .ifr: return "قواعد الطيران الآلي (صعب)"
        }
    }
}
