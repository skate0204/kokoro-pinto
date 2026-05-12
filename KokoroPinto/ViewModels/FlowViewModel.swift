import Foundation
import Observation

struct ResultWordPresentation: Identifiable, Hashable {
    let word: String
    let closeness: Int

    var id: String { word }
}

@Observable
final class FlowViewModel {
    let flow: EmotionFlow
    let prototypeCatalog: PrototypeResultWordsCatalog
    let legacyDictionary: EmotionWordDictionary

    var selectedCategory: EmotionCategory?
    var currentNode: FlowNode?
    var selectedResult: EmotionResult?
    var routeLabels: [String] = []
    var selectedDepth: WordDepth = .normal

    private var nodeHistory: [FlowNode] = []
    private var visitedChoiceLabels: [String] = []

    init(
        flow: EmotionFlow = FlowLoader.load(),
        prototypeCatalog: PrototypeResultWordsCatalog = WordDictionaryLoader.loadPrototypeCatalog(),
        legacyDictionary: EmotionWordDictionary = WordDictionaryLoader.loadLegacyDictionary()
    ) {
        self.flow = flow
        self.prototypeCatalog = prototypeCatalog
        self.legacyDictionary = legacyDictionary
    }

    var nodesById: [String: FlowNode] {
        Dictionary(uniqueKeysWithValues: flow.nodes.map { ($0.id, $0) })
    }

    var resultsById: [String: EmotionResult] {
        Dictionary(uniqueKeysWithValues: flow.results.map { ($0.id, $0) })
    }

    var displayRouteText: String {
        routeLabels.joined(separator: " → ")
    }

    var currentStep: Int {
        nodeHistory.count + (currentNode == nil ? 0 : 1)
    }

    var totalSteps: Int {
        guard let currentNode else { return max(nodeHistory.count, 1) }
        return max(currentStep + maxDepth(from: currentNode) - 1, currentStep)
    }

    func start(category: EmotionCategory) {
        selectedCategory = category
        selectedResult = nil
        routeLabels = [category.label]
        selectedDepth = .normal
        nodeHistory = []
        visitedChoiceLabels = []
        currentNode = flow.nodes.first { $0.categoryId == category.id && $0.id.hasSuffix("start") }
            ?? flow.nodes.first { $0.categoryId == category.id }
    }

    func choose(_ choice: FlowChoice) {
        guard let node = currentNode else { return }
        nodeHistory.append(node)
        visitedChoiceLabels.append(choice.label)
        routeLabels.append(choice.label)

        if let resultId = choice.resultId, let result = resultsById[resultId] {
            selectedResult = result
            currentNode = nil
            return
        }

        if let nextNodeId = choice.nextNodeId, let nextNode = nodesById[nextNodeId] {
            currentNode = nextNode
        }
    }

    func goBack() {
        if selectedResult != nil {
            selectedResult = nil
        }

        if !routeLabels.isEmpty {
            routeLabels.removeLast()
        }
        if !visitedChoiceLabels.isEmpty {
            visitedChoiceLabels.removeLast()
        }
        currentNode = nodeHistory.popLast()
    }

    func reset() {
        selectedCategory = nil
        currentNode = nil
        selectedResult = nil
        routeLabels = []
        selectedDepth = .normal
        nodeHistory = []
        visitedChoiceLabels = []
    }

    func resultWordItem(for resultId: String) -> PrototypeResultWordItem? {
        prototypeCatalog.items.first { $0.resultId == resultId }
    }

    func legacyWordItem(for resultId: String) -> EmotionWordItem? {
        legacyDictionary.items.first { $0.resultId == resultId }
    }

    func displayedWords(for result: EmotionResult) -> [String] {
        if let item = resultWordItem(for: result.id) {
            let words = item.words(for: selectedDepth)
            if !words.isEmpty { return Array(words.prefix(5)) }
        }

        if let legacyItem = legacyWordItem(for: result.id) {
            let words = legacyItem.words(for: selectedDepth)
            if !words.isEmpty { return Array(words.prefix(5)) }
        }

        return Array(result.words.prefix(5))
    }

    func presentedWords(for result: EmotionResult) -> [ResultWordPresentation] {
        displayedWords(for: result).enumerated().map { index, word in
            ResultWordPresentation(word: word, closeness: max(10 - index, 6 - max(index - 2, 0)))
        }
    }

    func nearbyWords(for result: EmotionResult) -> [String] {
        if let item = resultWordItem(for: result.id) {
            let near = item.group("near")
            if !near.isEmpty { return Array(near.prefix(4)) }
        }

        let words = result.words.filter { !displayedWords(for: result).contains($0) }
        return Array(words.prefix(4))
    }

    func needs(for result: EmotionResult) -> [String] {
        if let item = resultWordItem(for: result.id) {
            let words = item.group("need")
            if !words.isEmpty { return Array(words.prefix(4)) }
        }

        return Array(result.needs.prefix(4))
    }

    func care(for result: EmotionResult) -> [String] {
        Array(result.care.prefix(3))
    }

    func detail(for word: String, result: EmotionResult) -> WordDetail {
        if let detail = resultWordItem(for: result.id)?.detail(for: word) {
            return detail
        }

        if let detail = legacyWordItem(for: result.id)?.details[word] {
            return detail
        }

        return WordDetail(
            meaning: result.description,
            situations: Array(result.situations.prefix(3)),
            related: Array(result.words.filter { $0 != word }.prefix(3)),
            hint: result.care.first ?? "今の気持ちを一文だけでも書いてみると、少し輪郭が見えやすくなることがあります。"
        )
    }

    private func maxDepth(from node: FlowNode) -> Int {
        var visited = Set<String>()
        return maxDepth(node, visited: &visited)
    }

    private func maxDepth(_ node: FlowNode, visited: inout Set<String>) -> Int {
        if visited.contains(node.id) { return 1 }
        visited.insert(node.id)

        let depths = node.choices.compactMap { choice -> Int? in
            if choice.resultId != nil { return 1 }
            guard let nextNodeId = choice.nextNodeId, let nextNode = nodesById[nextNodeId] else { return nil }
            return 1 + maxDepth(nextNode, visited: &visited)
        }

        visited.remove(node.id)
        return depths.max() ?? 1
    }
}
