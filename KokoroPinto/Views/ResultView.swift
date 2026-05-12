import SwiftUI

struct ResultView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: FlowViewModel
    let result: EmotionResult

    @State private var expandedWord: String?

    private var displayedWords: [ResultWordPresentation] {
        viewModel.presentedWords(for: result)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("今の気持ちに近いかもしれない言葉")
                    .font(.kpRounded(size: 28, weight: .bold))
                    .foregroundStyle(Color.kpText)

                Text(viewModel.displayRouteText)
                    .font(.kpRounded(size: 13, weight: .medium))
                    .foregroundStyle(Color.kpSecondaryText)

                depthSelector

                VStack(spacing: 12) {
                    ForEach(displayedWords) { item in
                        WordAccordionCard(
                            word: item.word,
                            closeness: item.closeness,
                            detail: viewModel.detail(for: item.word, result: result),
                            isExpanded: expandedWord == item.word,
                            action: {
                                withAnimation(.smooth) {
                                    expandedWord = expandedWord == item.word ? nil : item.word
                                }
                            }
                        )
                    }
                }

                SectionCard(title: "少し混ざっていそうな気持ち", items: viewModel.nearbyWords(for: result))
                SectionCard(title: "奥にありそうな欲求", items: viewModel.needs(for: result))
                SectionCard(title: "ニーズ・セルフケアのヒント", items: viewModel.care(for: result))

                NavigationLink {
                    SaveMemoView(
                        result: result,
                        routeLabels: viewModel.routeLabels,
                        selectedDepth: viewModel.selectedDepth,
                        displayedWords: viewModel.displayedWords(for: result),
                        needs: viewModel.needs(for: result),
                        care: viewModel.care(for: result)
                    )
                } label: {
                    Text("メモして保存")
                        .font(.kpRounded(size: 18, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.kpPrimary)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                }
                .buttonStyle(.plain)

                SecondaryButton(title: "カテゴリ選択へ戻る") {
                    viewModel.reset()
                    dismiss()
                }

                Text("これは診断ではなく、気持ちを整理するための言葉です。つらさが強いときは、身近な人や専門機関に相談してください。")
                    .font(.kpRounded(size: 13))
                    .foregroundStyle(Color.kpSecondaryText)
                    .padding(.top, 6)
            }
            .padding(20)
        }
        .background(Color.kpBackground)
    }

    private var depthSelector: some View {
        KPCard(fillColor: Color.kpPrimarySoft.opacity(0.72)) {
            VStack(alignment: .leading, spacing: 12) {
                Text("ことばの深さ")
                    .font(.kpRounded(size: 16, weight: .semibold))
                    .foregroundStyle(Color.kpText)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(WordDepth.allCases) { depth in
                            Button {
                                withAnimation(.smooth) {
                                    viewModel.selectedDepth = depth
                                    expandedWord = nil
                                }
                            } label: {
                                Text(depth.label)
                                    .font(.kpRounded(size: 14, weight: .semibold))
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 10)
                                    .background(
                                        depth == viewModel.selectedDepth ? Color.kpPrimary : Color.white.opacity(0.9)
                                    )
                                    .foregroundStyle(depth == viewModel.selectedDepth ? Color.white : Color.kpText)
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

private struct WordAccordionCard: View {
    let word: String
    let closeness: Int
    let detail: WordDetail
    let isExpanded: Bool
    let action: () -> Void

    var body: some View {
        KPCard(fillColor: .white) {
            VStack(alignment: .leading, spacing: 14) {
                Button(action: action) {
                    HStack(alignment: .center, spacing: 12) {
                        Circle()
                            .fill(Color.kpAccentPeach)
                            .frame(width: 28, height: 28)
                            .overlay(
                                Image(systemName: "sparkle")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundStyle(Color.kpPrimary)
                            )

                        Text(word)
                            .font(.kpRounded(size: 20, weight: .semibold))
                            .foregroundStyle(Color.kpText)

                        Spacer()

                        Text("強さ \(closeness)/10")
                            .font(.kpRounded(size: 13, weight: .medium))
                            .foregroundStyle(Color.kpSecondaryText)

                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .foregroundStyle(Color.kpSecondaryText)
                    }
                }
                .buttonStyle(.plain)

                if isExpanded {
                    Divider()

                    VStack(alignment: .leading, spacing: 12) {
                        detailSection(title: "かんたんな意味", items: [detail.meaning])
                        detailSection(title: "こんな時に出やすい", items: detail.situations)
                        detailSection(title: "近い気持ち", items: detail.related)
                        detailSection(title: "ひとことヒント", items: [detail.hint])
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func detailSection(title: String, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.kpRounded(size: 14, weight: .semibold))
                .foregroundStyle(Color.kpPrimary)

            ForEach(items, id: \.self) { item in
                Text(item)
                    .font(.kpRounded(size: 15))
                    .foregroundStyle(Color.kpSecondaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
