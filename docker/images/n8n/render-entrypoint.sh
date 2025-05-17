#!/bin/sh
set -e

# カスタム証明書のサポート
if [ -d /opt/custom-certificates ]; then
  echo "Trusting custom certificates from /opt/custom-certificates."
  export NODE_OPTIONS="--use-openssl-ca $NODE_OPTIONS"
  export SSL_CERT_DIR=/opt/custom-certificates
  c_rehash /opt/custom-certificates
fi

# Renderの環境変数を使用した設定
if [ -n "$RENDER_EXTERNAL_URL" ]; then
  export WEBHOOK_TUNNEL_URL="$RENDER_EXTERNAL_URL"
  echo "Webhook URL set to: $WEBHOOK_TUNNEL_URL"
fi

if [ -n "$RENDER_EXTERNAL_HOSTNAME" ]; then
  export N8N_HOST="$RENDER_EXTERNAL_HOSTNAME"
  echo "n8n host set to: $N8N_HOST"
fi

# データディレクトリの確認と作成
if [ ! -d "/data" ]; then
  mkdir -p /data
  chown -R node:node /data
fi

if [ ! -d "/data/.n8n" ]; then
  mkdir -p /data/.n8n
  chown -R node:node /data/.n8n
fi

# 不要なサービスを無効化（無料プラン向け）
export N8N_DIAGNOSTICS_ENABLED=false
export N8N_HIRING_BANNER_ENABLED=false
export EXECUTIONS_PROCESS=main
export EXECUTIONS_MODE=regular
export N8N_DISABLE_PRODUCTION_MAIN_PROCESS=false

# メモリ使用量の最適化（無料プラン向け）
export NODE_OPTIONS="--max-old-space-size=512"

# 実行
if [ "$#" -gt 0 ]; then
  # コマンドライン引数がある場合
  exec n8n "$@"
else
  # 引数がない場合はデフォルトで起動
  exec n8n start
fi 