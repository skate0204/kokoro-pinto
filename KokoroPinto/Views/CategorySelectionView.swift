import SwiftUI

struct CategorySelectionView: View {
    @Bindable var viewModel: FlowViewModel

    private let columns = [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)]

    private var knownCategories: [EmotionCategory] {
        viewModel.flow.categories.filter { $0.id != "unknown" }
    }

    private var unknownCategory: EmotionCategory? {
        viewModel.flow.categories.first { $0.id == "unknown" }
    }

    var body: some View {
        ZStack {
            Color.kpBackground.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    Text("今の気持ちに近いものは？")
                        .font(.kpRounded(size: 28, weight: .bold))
                        .foregroundStyle(Color.kpText)

                    Text("ざっくりで大丈夫です。いちばん近そうな入口から始めてみましょう。")
                        .font(.kpRounded(size: 15))
                        .foregroundStyle(Color.kpSecondaryText)

                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(knownCategories) { category in
                            NavigationLink {
                                QuestionFlowView(viewModel: viewModel)
                                    .onAppear { viewModel.start(category: category) }
                            } label: {
                                CategoryCard(category: category)
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    if let unknownCategory {
                        NavigationLink {
                            QuestionFlowView(viewModel: viewModel)
                                .onAppear { viewModel.start(category: unknownCategory) }
                        } label: {
                            HStack(spacing: 10) {
                                Text("+")
                                    .font(.kpRounded(size: 22, weight: .bold))
                                Text("よくわからない")
                                    .font(.kpRounded(size: 17, weight: .semibold))
                            }
                            .foregroundStyle(Color.kpText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .stroke(Color.kpBorder, lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("感情カテゴリ")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct CategoryCard: View {
    let category: EmotionCategory

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(category.emoji)
                    .font(.system(size: 30))
                    .frame(width: 48, height: 48)
                    .background(Color.kpPrimarySoft)
                    .clipShape(Circle())
                Spacer()
            }

            Text(category.label)
                .font(.kpRounded(size: 18, weight: .semibold))
                .foregroundStyle(Color.kpText)

            Text(category.description)
                .font(.kpRounded(size: 13))
                .foregroundStyle(Color.kpSecondaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, minHeight: 150, alignment: .topLeading)
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.kpBorder, lineWidth: 1)
        )
    }
}
