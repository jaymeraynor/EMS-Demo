#!/usr/bin/env bash
# 使用方式：
#   PROJECT_ID=你的專案ID REGION=asia-east1 SERVICE=elitegets-demo bash deploy.sh
set -euo pipefail

: "${PROJECT_ID:?請設定 PROJECT_ID}"
REGION="${REGION:-asia-east1}"
SERVICE="${SERVICE:-elitegets-demo}"
REPO="${REPO:-elitegets}"

gcloud config set project "$PROJECT_ID"
gcloud services enable run.googleapis.com artifactregistry.googleapis.com cloudbuild.googleapis.com

# 建立映像檔儲存庫（已存在則略過）
gcloud artifacts repositories describe "$REPO" --location="$REGION" >/dev/null 2>&1 || \
  gcloud artifacts repositories create "$REPO" --repository-format=docker --location="$REGION"

IMAGE="$REGION-docker.pkg.dev/$PROJECT_ID/$REPO/$SERVICE:$(date +%Y%m%d-%H%M%S)"

# 雲端建置映像檔並部署
gcloud builds submit --tag "$IMAGE" .
gcloud run deploy "$SERVICE" \
  --image "$IMAGE" \
  --region "$REGION" \
  --platform managed \
  --allow-unauthenticated \
  --port 8080 \
  --min-instances 0 \
  --max-instances 2

echo "完成。服務網址："
gcloud run services describe "$SERVICE" --region "$REGION" --format='value(status.url)'
