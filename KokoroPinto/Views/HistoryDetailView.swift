import SwiftUI

struct HistoryDetailView: View {
    let record: EmotionRecord

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text(record.createdAt.formatted(date: .long, time: .shortened))
                    .font(.kpRounded(size: 13))
                    .foregroundStyle(Color.kpSecondaryText)

                KPCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(record.resultTitle)
                            .font(.kpRounded(size: 24, weight: .bold))
                            .foregroundStyle(Color.kpPrimary)

                        HStack(spacing: 12) {
                            Text("深さ: \(record.selectedDepth.label)")
                            Text("強さ: \(record.intensity)/10")
                        }
                        .font(.kpRounded(size: 14, weight: .medium))
                        .foregroundStyle(Color.kpSecondaryText)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                SectionCard(title: "表示された言葉", items: record.displayedWords)
                SectionCard(title: "たどったルート", items: [record.routeLabels.joined(separator: " → ")])
                SectionCard(title: "奥にありそうな欲求", items: record.needs)
                SectionCard(title: "セルフケアのヒント", items: record.care)

                if !record.memo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    SectionCard(title: "保存メモ", items: [record.memo])
                }
            }
            .padding(20)
        }
        .background(Color.kpBackground)
        .navigationTitle("履歴詳細")
        .navigationBarTitleDisplayMode(.inline)
    }
}
