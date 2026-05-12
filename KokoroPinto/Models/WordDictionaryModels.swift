import Foundation

enum WordDepth: String, Codable, CaseIterable, Identifiable {
    case easy
    case normal
    case detailed
    case advanced
    case poetic

    var id: String { rawValue }

    var label: String {
        switch self {
        case .easy: return "やさしい"
        case .normal: return "ふつう"
        case .detailed: return "くわしい"
        case .advanced: return "難しい"
        case .poetic: return "詩的"
        }
    }
}

struct PrototypeResultWordsCatalog: Codable {
    let version: String
    let items: [PrototypeResultWordItem]
}

struct PrototypeResultWordItem: Codable, Identifiable, Hashable {
    var id: String { resultId }

    let resultId: String
    let familyId: String?
    let familyLabel: String?
    let title: String
    let coreIntent: String?
    let wordsByDepth: [String: [String]]
    let groups: [String: [String]]
    let wordDetails: [String: WordDetail]

    func words(for depth: WordDepth) -> [String] {
        let preferred = wordsByDepth[depth.rawValue] ?? []
        if !preferred.isEmpty { return preferred }
        return wordsByDepth[WordDepth.normal.rawValue] ?? []
    }

    func group(_ id: String) -> [String] {
        groups[id] ?? []
    }

    func detail(for word: String) -> WordDetail? {
        wordDetails[word]
    }
}

struct EmotionWordDictionary: Codable {
    let version: String
    let depthLevels: [DepthLevel]
    let items: [EmotionWordItem]
}

struct DepthLevel: Codable, Hashable {
    let id: String
    let label: String
}

struct EmotionWordItem: Codable, Identifiable, Hashable {
    var id: String { resultId }

    let resultId: String
    let title: String
    let words: [String: [String]]
    let details: [String: WordDetail]

    func words(for depth: WordDepth) -> [String] {
        let preferred = words[depth.rawValue] ?? []
        if !preferred.isEmpty { return preferred }
        return words[WordDepth.normal.rawValue] ?? []
    }
}

struct WordDetail: Codable, Hashable {
    let meaning: String
    let situations: [String]
    let related: [String]
    let hint: String
}
