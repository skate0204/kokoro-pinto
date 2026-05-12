import SwiftUI

struct MemoHubView: View {
    var body: some View {
        ZStack {
            Color.kpBackground.ignoresSafeArea()

            VStack(spacing: 18) {
                KPCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("メモ")
                            .font(.kpRounded(size: 28, weight: .bold))
                            .foregroundStyle(Color.kpText)

                        Text("結果画面からメモを保存すると、履歴といっしょにここから振り返れます。")
                            .font(.kpRounded(size: 15))
                            .foregroundStyle(Color.kpSecondaryText)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(20)
        }
        .navigationTitle("メモ")
    }
}
