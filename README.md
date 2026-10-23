# EMS-Demo
## 示範部署（Cloud Run）

- `Dockerfile`、`nginx/templates/default.conf.template`：容器設定
- `index.html`：示範頁面（模擬數據，不含真實電表資料）
- `deploy.sh`：部署腳本，使用方式：`PROJECT_ID=你的專案ID REGION=asia-east1 bash deploy.sh`
