import Foundation

struct EmotionFlow: Codable {
    let version: String
    let categories: [EmotionCategory]
    let nodes: [FlowNode]
    let results: [EmotionResult]
}

struct EmotionCategory: Codable, Identifiable, Hashable {
    let id: String
    let label: String
    let emoji: String
    let description: String
}

struct FlowNode: Codable, Identifiable, Hashable {
    let id: String
    let categoryId: String
    let question: String
    let breadcrumbLabel: String
    let choices: [FlowChoice]
}

struct FlowChoice: Codable, Identifiable, Hashable {
    var id: String { label }
    let label: String
    let nextNodeId: String?
    let resultId: String?
}

struct EmotionResult: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let words: [String]
    let description: String
    let situations: [String]
    let needs: [String]
    let care: [String]
}
