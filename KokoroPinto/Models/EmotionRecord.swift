import Foundation
import SwiftData

@Model
final class EmotionRecord {
    var createdAt: Date
    var resultId: String
    var resultTitle: String
    var routeLabelsJSON: String
    var selectedDepthRaw: String
    var displayedWordsJSON: String
    var needsJSON: String
    var careJSON: String
    var intensity: Int
    var memo: String

    init(
        createdAt: Date = Date(),
        resultId: String,
        resultTitle: String,
        routeLabels: [String],
        selectedDepth: WordDepth,
        displayedWords: [String],
        needs: [String],
        care: [String],
        intensity: Int,
        memo: String
    ) {
        self.createdAt = createdAt
        self.resultId = resultId
        self.resultTitle = resultTitle
        self.routeLabelsJSON = Self.encode(routeLabels)
        self.selectedDepthRaw = selectedDepth.rawValue
        self.displayedWordsJSON = Self.encode(displayedWords)
        self.needsJSON = Self.encode(needs)
        self.careJSON = Self.encode(care)
        self.intensity = intensity
        self.memo = memo
    }

    var routeLabels: [String] {
        Self.decodeArray(routeLabelsJSON)
    }

    var displayedWords: [String] {
        Self.decodeArray(displayedWordsJSON)
    }

    var needs: [String] {
        Self.decodeArray(needsJSON)
    }

    var care: [String] {
        Self.decodeArray(careJSON)
    }

    var selectedDepth: WordDepth {
        WordDepth(rawValue: selectedDepthRaw) ?? .normal
    }

    private static func encode(_ values: [String]) -> String {
        let data = (try? JSONEncoder().encode(values)) ?? Data("[]".utf8)
        return String(decoding: data, as: UTF8.self)
    }

    private static func decodeArray(_ value: String) -> [String] {
        let data = Data(value.utf8)
        return (try? JSONDecoder().decode([String].self, from: data)) ?? []
    }
}
