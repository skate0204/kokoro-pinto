import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack {
            Color.kpBackground.ignoresSafeArea()

            VStack(spacing: 18) {
                KPCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("このアプリについて")
                            .font(.kpRounded(size: 24, weight: .bold))
                            .foregroundStyle(Color.kpText)

                        Text("これは診断ではなく、気持ちを整理するための言葉です。つらさが強いときは、身近な人や専門機関に相談してください。")
                            .font(.kpRounded(size: 15))
                            .foregroundStyle(Color.kpSecondaryText)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(20)
        }
        .navigationTitle("設定")
    }
}
