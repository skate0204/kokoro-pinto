import SwiftUI
import SwiftData

struct HistoryListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \EmotionRecord.createdAt, order: .reverse) private var records: [EmotionRecord]

    var body: some View {
        ZStack {
            Color.kpBackground.ignoresSafeArea()

            if records.isEmpty {
                ContentUnavailableView(
                    "まだ履歴がありません",
                    systemImage: "clock",
                    description: Text("結果を保存すると、ここに一覧で表示されます。")
                )
            } else {
                List {
                    ForEach(records) { record in
                        NavigationLink {
                            HistoryDetailView(record: record)
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(record.resultTitle)
                                    .font(.kpRounded(size: 18, weight: .semibold))
                                    .foregroundStyle(Color.kpText)

                                Text(record.createdAt.formatted(date: .abbreviated, time: .shortened))
                                    .font(.kpRounded(size: 13))
                                    .foregroundStyle(Color.kpSecondaryText)

                                Text(record.displayedWords.joined(separator: " / "))
                                    .font(.kpRounded(size: 14))
                                    .foregroundStyle(Color.kpSecondaryText)
                                    .lineLimit(2)

                                HStack {
                                    Text("深さ: \(record.selectedDepth.label)")
                                    Text("強さ: \(record.intensity)/10")
                                }
                                .font(.kpRounded(size: 12, weight: .medium))
                                .foregroundStyle(Color.kpPrimary)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .navigationTitle("履歴一覧")
    }

    private func delete(at offsets: IndexSet) {
        for offset in offsets {
            modelContext.delete(records[offset])
        }
    }
}
