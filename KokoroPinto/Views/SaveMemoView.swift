import SwiftUI
import SwiftData

struct SaveMemoView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let result: EmotionResult
    let routeLabels: [String]
    let selectedDepth: WordDepth
    let displayedWords: [String]
    let needs: [String]
    let care: [String]

    @State private var intensity: Double = 6
    @State private var memo = ""
    @State private var didSave = false

    var body: some View {
        ZStack {
            Color.kpBackground.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text("メモを追加（任意）")
                        .font(.kpRounded(size: 28, weight: .bold))
                        .foregroundStyle(Color.kpText)

                    KPCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(result.title)
                                .font(.kpRounded(size: 18, weight: .semibold))
                                .foregroundStyle(Color.kpText)
                            Text(displayedWords.joined(separator: " / "))
                                .font(.kpRounded(size: 14))
                                .foregroundStyle(Color.kpSecondaryText)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    KPCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("気持ちの強さ")
                                .font(.kpRounded(size: 17, weight: .semibold))
                            Text("\(Int(intensity)) / 10")
                                .font(.kpRounded(size: 15))
                                .foregroundStyle(Color.kpSecondaryText)
                            Slider(value: $intensity, in: 1...10, step: 1)
                                .tint(Color.kpPrimary)
                        }
                    }

                    KPCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("メモ")
                                .font(.kpRounded(size: 17, weight: .semibold))

                            ZStack(alignment: .topLeading) {
                                if memo.isEmpty {
                                    Text("今日の出来事や気づきなどを自由に書いてみましょう。")
                                        .font(.kpRounded(size: 15))
                                        .foregroundStyle(Color.kpSecondaryText.opacity(0.8))
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 10)
                                }

                                TextEditor(text: $memo)
                                    .font(.kpRounded(size: 15))
                                    .frame(minHeight: 180)
                                    .scrollContentBackground(.hidden)
                            }
                        }
                    }

                    PrimaryButton(title: didSave ? "保存しました" : "保存する") {
                        save()
                    }

                    if didSave {
                        SecondaryButton(title: "前の画面へ戻る") {
                            dismiss()
                        }
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("保存 / メモ")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func save() {
        let record = EmotionRecord(
            resultId: result.id,
            resultTitle: result.title,
            routeLabels: routeLabels,
            selectedDepth: selectedDepth,
            displayedWords: displayedWords,
            needs: needs,
            care: care,
            intensity: Int(intensity),
            memo: memo
        )
        modelContext.insert(record)
        didSave = true
    }
}
