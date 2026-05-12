import SwiftUI

struct HomeView: View {
    @Bindable var viewModel: FlowViewModel

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.kpBackground, Color.white],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    Spacer(minLength: 20)

                    VStack(spacing: 20) {
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .fill(Color.white)
                            .frame(width: 110, height: 110)
                            .overlay {
                                Image(systemName: "heart.text.square")
                                    .font(.system(size: 50, weight: .regular, design: .rounded))
                                    .foregroundStyle(Color.kpPrimary)
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 28, style: .continuous)
                                    .stroke(Color.kpBorder, lineWidth: 1)
                            )

                        VStack(spacing: 10) {
                            Text("こころのピント")
                                .font(.kpRounded(size: 34, weight: .bold))
                                .foregroundStyle(Color.kpText)

                            Text("ぼやけた気持ちに、ピントを合わせよう")
                                .font(.kpRounded(size: 19, weight: .medium))
                                .foregroundStyle(Color.kpText)
                                .multilineTextAlignment(.center)

                            Text("質問に答えていくことで、曖昧な気持ちから、今の自分に近い言葉や背景のニーズを探していきます。")
                                .font(.kpRounded(size: 15))
                                .foregroundStyle(Color.kpSecondaryText)
                                .multilineTextAlignment(.center)
                                .padding(.top, 4)
                        }
                    }
                    .padding(.top, 22)

                    KPCard(fillColor: Color.white.opacity(0.88)) {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("コンセプト", systemImage: "lightbulb")
                                .font(.kpRounded(size: 21, weight: .bold))
                                .foregroundStyle(Color.kpPrimary)

                            Text("感情を「見つける」「理解する」「受け止める」「整える」ための、やさしい対話型プロトタイプです。")
                                .font(.kpRounded(size: 15))
                                .foregroundStyle(Color.kpSecondaryText)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    NavigationLink {
                        CategorySelectionView(viewModel: viewModel)
                    } label: {
                        Text("はじめる")
                            .font(.kpRounded(size: 18, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 58)
                            .background(Color.kpPrimary)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    }
                    .buttonStyle(.plain)

                    NavigationLink {
                        HistoryListView()
                    } label: {
                        Text("履歴を見る")
                            .font(.kpRounded(size: 16, weight: .semibold))
                            .foregroundStyle(Color.kpPrimary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .stroke(Color.kpBorder, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)

                    Text("これは診断ではなく、気持ちを整理するための言葉です。つらさが強いときは、身近な人や専門機関に相談してください。")
                        .font(.kpRounded(size: 13))
                        .foregroundStyle(Color.kpSecondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 12)
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
