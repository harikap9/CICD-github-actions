#!/usr/bin/env bash
set -euo pipefail

ARTIFACT_PATH="${1:-}"
DEPLOY_TARGET="${2:-}"
REMOTE_USER="${3:-}"
REMOTE_HOST="${4:-}"

if [[ -z "$ARTIFACT_PATH" || -z "$DEPLOY_TARGET" || -z "$REMOTE_USER" || -z "$REMOTE_HOST" ]]; then
  echo "Usage:"
  echo "  bash scripts/deploy-jar-war.sh <artifact.jar|artifact.war> <systemd-jar|tomcat-war> <user> <host>"
  exit 1
fi

if [[ ! -f "$ARTIFACT_PATH" ]]; then
  echo "Artifact not found: $ARTIFACT_PATH"
  exit 1
fi

case "$DEPLOY_TARGET" in
  systemd-jar)
    echo "Deploying JAR to systemd service..."
    scp "$ARTIFACT_PATH" "$REMOTE_USER@$REMOTE_HOST:/tmp/demo-app.jar"
    ssh "$REMOTE_USER@$REMOTE_HOST" "sudo mkdir -p /opt/demo-app && sudo mv /tmp/demo-app.jar /opt/demo-app/demo-app.jar && sudo systemctl restart demo-app"
    ;;
  tomcat-war)
    echo "Deploying WAR to Tomcat..."
    scp "$ARTIFACT_PATH" "$REMOTE_USER@$REMOTE_HOST:/tmp/application.war"
    ssh "$REMOTE_USER@$REMOTE_HOST" "sudo mv /tmp/application.war /opt/tomcat/webapps/application.war && sudo systemctl restart tomcat"
    ;;
  *)
    echo "Unsupported deployment target: $DEPLOY_TARGET"
    echo "Allowed targets: systemd-jar, tomcat-war"
    exit 1
    ;;
esac

echo "Deployment command completed."
