import Foundation

enum WordDictionaryLoader {
    static func loadPrototypeCatalog() -> PrototypeResultWordsCatalog {
        guard let url = Bundle.main.url(forResource: "prototype_result_words_flat_ja", withExtension: "json") else {
            return PrototypeResultWordsCatalog(version: "fallback", items: [])
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(PrototypeResultWordsCatalog.self, from: data)
        } catch {
            print("Failed to load prototype_result_words_flat_ja.json: \(error)")
            return PrototypeResultWordsCatalog(version: "fallback", items: [])
        }
    }

    static func loadLegacyDictionary() -> EmotionWordDictionary {
        guard let url = Bundle.main.url(forResource: "emotion_word_dictionary_ja", withExtension: "json") else {
            return EmotionWordDictionary(version: "fallback", depthLevels: [], items: [])
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(EmotionWordDictionary.self, from: data)
        } catch {
            print("Failed to load emotion_word_dictionary_ja.json: \(error)")
            return EmotionWordDictionary(version: "fallback", depthLevels: [], items: [])
        }
    }
}
