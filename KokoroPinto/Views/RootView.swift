import SwiftUI

struct RootView: View {
    @State private var viewModel = FlowViewModel()

    var body: some View {
        TabView {
            NavigationStack {
                HomeView(viewModel: viewModel)
            }
            .tabItem {
                Label("ホーム", systemImage: "house")
            }

            NavigationStack {
                HistoryListView()
            }
            .tabItem {
                Label("履歴", systemImage: "clock")
            }

            NavigationStack {
                MemoHubView()
            }
            .tabItem {
                Label("メモ", systemImage: "square.and.pencil")
            }

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("設定", systemImage: "person")
            }
        }
        .tint(.kpPrimary)
    }
}
