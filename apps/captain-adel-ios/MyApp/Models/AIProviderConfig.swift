import Foundation

enum AIProviderType: String, CaseIterable, Identifiable, Codable {
    case offlineDoctrine = "offline"
    case huggingFace = "huggingface"
    case flyGACA = "flygaca"
    case openAICompatible = "openai"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .offlineDoctrine:
            return "Offline GACAR Doctrine (Local)"
        case .huggingFace:
            return "Hugging Face Inference"
        case .flyGACA:
            return "Fly GACA Cloud RAG"
        case .openAICompatible:
            return "OpenAI-Compatible Custom API"
        }
    }
    
    var shortBadge: String {
        switch self {
        case .offlineDoctrine:
            return "OFFLINE"
        case .huggingFace:
            return "HF LIVE"
        case .flyGACA:
            return "FLY GACA"
        case .openAICompatible:
            return "CUSTOM"
        }
    }
    
    var defaultEndpoint: String {
        switch self {
        case .offlineDoctrine:
            return ""
        case .huggingFace:
            return "https://router.huggingface.co/hf-inference/models/flygaca/CaptAdel"
        case .flyGACA:
            return "https://api.flygaca.com/v1/chat"
        case .openAICompatible:
            return "https://api.openai.com/v1/chat/completions"
        }
    }
    
    var defaultModel: String {
        switch self {
        case .offlineDoctrine:
            return "GACAR-74-Local"
        case .huggingFace:
            return "flygaca/CaptAdel"
        case .flyGACA:
            return "captadel-v1"
        case .openAICompatible:
            return "gpt-4o-mini"
        }
    }
}

enum AIConnectionStatus: Equatable {
    case offline
    case connecting
    case connected(latencyMs: Int)
    case fallback(reason: String)
    
    var label: String {
        switch self {
        case .offline:
            return "OFFLINE · LOCAL"
        case .connecting:
            return "CONNECTING..."
        case .connected(let ms):
            return "LIVE · \(ms)ms"
        case .fallback:
            return "FALLBACK · LOCAL"
        }
    }
}

struct AIProviderConfig: Codable, Equatable {
    var provider: AIProviderType
    var endpointURL: String
    var modelName: String
    var temperature: Double
    var streamEnabled: Bool
    
    static var `default`: AIProviderConfig {
        AIProviderConfig(
            provider: .offlineDoctrine,
            endpointURL: "",
            modelName: "GACAR-74-Local",
            temperature: 0.2,
            streamEnabled: true
        )
    }
}
