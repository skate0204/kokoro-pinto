# こころのピント

SwiftUI で作った iOS プロトタイプです。  
質問フローに答えながら、今の気持ちに近い言葉を探し、メモと履歴をローカル保存できます。

## 実装済み

- ホーム画面
- 感情カテゴリ選択
- 質問フロー
- 結果画面
- ことばの深さ切り替え
- 結果語の説明カード
- メモ保存
- 履歴一覧
- 履歴詳細
- SwiftData によるローカル保存

## 技術

- iOS 17+
- SwiftUI
- SwiftData
- ローカル JSON 読み込み
- サーバー通信なし

## 開き方

1. macOS で `KokoroPinto.xcodeproj` を Xcode で開く
2. `KokoroPinto` scheme を選ぶ
3. iOS 17 以上の Simulator で Run

## 注意

- このリポジトリは MVP 段階です
- Windows 側では Xcode ビルド確認をしていません
- Mac で最初にビルドし、必要なら `project.pbxproj` や SwiftUI コードを微調整してください
