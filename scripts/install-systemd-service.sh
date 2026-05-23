#!/usr/bin/env bash
set -euo pipefail

APP_NAME="${1:-demo-app}"
APP_DIR="/opt/${APP_NAME}"

sudo mkdir -p "$APP_DIR"
sudo tee "/etc/systemd/system/${APP_NAME}.service" > /dev/null <<SERVICE
[Unit]
Description=${APP_NAME} Spring Boot service
After=network.target

[Service]
User=ubuntu
WorkingDirectory=${APP_DIR}
ExecStart=/usr/bin/java -jar ${APP_DIR}/${APP_NAME}.jar
Restart=always
RestartSec=10
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
SERVICE

sudo systemctl daemon-reload
sudo systemctl enable "${APP_NAME}"

echo "Service created: ${APP_NAME}"
echo "Copy your JAR to ${APP_DIR}/${APP_NAME}.jar, then run: sudo systemctl start ${APP_NAME}"
