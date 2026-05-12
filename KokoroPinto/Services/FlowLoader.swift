import Foundation

final class FlowLoader {
    static func load() -> EmotionFlow {
        if let url = Bundle.main.url(forResource: "emotion_flow_ja", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let flow = try? JSONDecoder().decode(EmotionFlow.self, from: data) {
            return flow
        }
        return fallbackFlow
    }

    private static let fallbackFlow = EmotionFlow(
        version: "fallback",
        categories: [
            EmotionCategory(id: "anger", label: "怒り", emoji: "😠", description: "納得できない感じ"),
            EmotionCategory(id: "unknown", label: "わからない", emoji: "❔", description: "身体感覚から探す")
        ],
        nodes: [
            FlowNode(
                id: "anger_start",
                categoryId: "anger",
                question: "その怒りは、どこに向いている感じ？",
                breadcrumbLabel: "怒り",
                choices: [
                    FlowChoice(label: "相手に向いている", nextNodeId: nil, resultId: "r_disrespected"),
                    FlowChoice(label: "自分に向いている", nextNodeId: nil, resultId: "r_self_disgust")
                ]
            )
        ],
        results: [
            EmotionResult(
                id: "r_disrespected",
                title: "軽視された感じ",
                words: ["軽視された感じ", "悔しさ", "傷つき"],
                description: "大切に扱われていないと感じたときの反応です。",
                situations: ["話を聞いてもらえなかった"],
                needs: ["尊重されたい"],
                care: ["一文で気持ちを書く"]
            ),
            EmotionResult(
                id: "r_self_disgust",
                title: "自己嫌悪",
                words: ["自己嫌悪", "後悔", "情けなさ"],
                description: "自分を責めたくなる状態です。",
                situations: ["同じ失敗を繰り返した"],
                needs: ["やり直したい"],
                care: ["次の一手だけ決める"]
            )
        ]
    )
}
