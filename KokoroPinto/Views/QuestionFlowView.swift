import SwiftUI

struct QuestionFlowView: View {
    @Bindable var viewModel: FlowViewModel

    var body: some View {
        ZStack {
            Color.kpBackground.ignoresSafeArea()

            if let result = viewModel.selectedResult {
                ResultView(viewModel: viewModel, result: result)
            } else if let node = viewModel.currentNode {
                VStack(alignment: .leading, spacing: 20) {
                    Text(viewModel.displayRouteText)
                        .font(.kpRounded(size: 13, weight: .medium))
                        .foregroundStyle(Color.kpSecondaryText)
                        .lineLimit(3)

                    ProgressView(value: Double(viewModel.currentStep), total: Double(max(viewModel.totalSteps, 1)))
                        .tint(Color.kpPrimary)

                    KPCard(fillColor: Color.white.opacity(0.94)) {
                        VStack(alignment: .leading, spacing: 14) {
                            Text(node.question)
                                .font(.kpRounded(size: 28, weight: .bold))
                                .foregroundStyle(Color.kpText)
                                .multilineTextAlignment(.leading)

                            Text("1画面1質問で、しっくりくるものをひとつ選んでください。")
                                .font(.kpRounded(size: 15))
                                .foregroundStyle(Color.kpSecondaryText)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    VStack(spacing: 12) {
                        ForEach(node.choices) { choice in
                            Button {
                                withAnimation(.smooth) {
                                    viewModel.choose(choice)
                                }
                            } label: {
                                HStack {
                                    Text(choice.label)
                                        .font(.kpRounded(size: 17, weight: .semibold))
                                        .foregroundStyle(Color.kpText)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(minHeight: 56)
                                .padding(.horizontal, 16)
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

                    Spacer(minLength: 12)

                    HStack {
                        Button {
                            withAnimation(.smooth) {
                                viewModel.goBack()
                            }
                        } label: {
                            Label("戻る", systemImage: "chevron.left")
                                .font(.kpRounded(size: 15, weight: .semibold))
                        }
                        .disabled(viewModel.routeLabels.count <= 1)

                        Spacer()

                        Text("\(viewModel.currentStep)/\(max(viewModel.totalSteps, viewModel.currentStep))")
                            .font(.kpRounded(size: 14, weight: .medium))
                            .foregroundStyle(Color.kpSecondaryText)
                    }
                }
                .padding(20)
            } else {
                ContentUnavailableView("フローが見つかりません", systemImage: "questionmark.circle")
            }
        }
        .navigationTitle("質問フロー")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    if viewModel.currentNode != nil || viewModel.selectedResult != nil {
                        viewModel.goBack()
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color.kpText)
                }
                .disabled(viewModel.routeLabels.count <= 1 && viewModel.selectedResult == nil)
            }
        }
    }
}
