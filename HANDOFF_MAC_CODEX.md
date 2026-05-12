# Mac Codex への引き継ぎ

## このプロジェクトでやってほしいこと

1. `KokoroPinto.xcodeproj` を Xcode で開く
2. iOS 17 以上の Simulator でビルドを通す
3. ビルドエラーがあれば修正する
4. JSON が Bundle から読めているか確認する
5. 質問フロー、結果画面、ことばの深さ切り替え、説明カード、保存、履歴を確認する
6. UI を `design/prototype_spec_v2.png` の雰囲気へ必要に応じて近づける

## 実装の要点

- `prototype_result_words_flat_ja.json` を優先して結果語を表示
- 深さ切り替え:
  - やさしい
  - ふつう
  - くわしい
  - 難しい
  - 詩的
- 語カードをタップすると説明カードを展開
- 説明がない語は `EmotionResult` からフォールバック
- SwiftData の配列保存は JSON 文字列化で実装

## 主なファイル

- `KokoroPinto/ViewModels/FlowViewModel.swift`
- `KokoroPinto/Views/ResultView.swift`
- `KokoroPinto/Views/SaveMemoView.swift`
- `KokoroPinto/Models/EmotionRecord.swift`
- `KokoroPinto/Resources/`

## 現状の制約

- Windows 環境で実装したため、Xcode 実ビルドは未確認
- `.xcodeproj` は手組みなので、最初に Xcode 上でターゲット設定を軽く確認してください
