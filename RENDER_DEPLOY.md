# Render へのn8nデプロイガイド（無料プラン対応）

このガイドではn8nをRenderプラットフォームの無料プランにデプロイする手順を説明します。

## 前提条件

- [Renderアカウント](https://render.com)
- GitHubなどのGitリポジトリにプロジェクトをプッシュしておく

## 無料プランでの制約

Renderの無料プランには以下の制約があります：

- 512MBのRAM制限
- 毎月750時間の使用制限（1インスタンスで常時稼働可能）
- 15分間のアイドル後にサービスがスリープ状態になる
- ストレージは1GBまで

以上の制約を考慮して最適化しています。

## デプロイ手順

### 1. Renderダッシュボードでの設定

1. Renderダッシュボードにログインします
2. 「New +」ボタンをクリックし、「Blueprint」を選択します
3. GitHubリポジトリを接続し、n8nプロジェクトを選択します
4. Render.yamlファイルが認識されると自動的にサービス構成が読み込まれます

### 2. 環境変数の設定

以下の環境変数はrender.yamlファイルで既に設定されていますが、必要に応じて追加・修正してください：

- `N8N_ENCRYPTION_KEY`: 自動生成されるセキュリティキー
- `DB_TYPE`: データベースタイプ（デフォルト: sqlite）
- `N8N_LOG_LEVEL`: ログレベル（デフォルト: info）
- `TZ`: タイムゾーン（デフォルト: Asia/Tokyo）
- `NODE_OPTIONS`: メモリ制限（無料プラン向けに512MBに設定済み）

### 3. 無料プラン向けの最適化設定

無料プランでのパフォーマンスを最適化するために以下の設定をしています：

- メモリ使用量を512MBに制限
- 診断機能を無効化
- メインプロセスでの実行に設定
- ディスク容量を1GBに制限

### 4. スリープ対策

Renderの無料プランでは15分間のアイドル後にサービスがスリープします。以下の対策を検討してください：

1. 定期的にアクセスする外部モニタリングサービスを設定する
2. n8n内で短い間隔（例：10分ごと）に自己呼び出しするワークフローを設定する

### 5. データの永続化

データの永続化のために1GBのディスクがマウントされます：

```yaml
disk:
  name: n8n-data
  mountPath: /data
  sizeGB: 1
```

重要なデータは定期的にバックアップすることをお勧めします。

### 6. トラブルシューティング

- デプロイに失敗した場合は、Renderのログを確認してください
- メモリ不足エラーが出る場合は、同時実行ワークフロー数を制限してください
- 長時間実行するワークフローはできるだけ避けてください
- 複雑なワークフローは複数の小さなワークフローに分割してください

## パフォーマンス向上のヒント

1. ワークフローは短時間で完了するように設計する
2. 大きなデータセットの処理は避ける
3. 頻繁に実行するワークフローはシンプルに保つ
4. 重要度の低いワークフローは実行頻度を下げる

## 注意事項

- 無料プランの制約上、本番環境での使用には適していません
- 商用利用する場合はn8nの[フェアコードライセンス](https://docs.n8n.io/reference/license/)に従ってください 