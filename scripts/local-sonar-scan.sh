#!/usr/bin/env bash
set -euo pipefail

SONAR_TOKEN="${SONAR_TOKEN:-}"

if [[ -z "$SONAR_TOKEN" ]]; then
  echo "Set SONAR_TOKEN before running this script."
  echo "Example: export SONAR_TOKEN='your-token'"
  exit 1
fi

mvn --batch-mode clean verify sonar:sonar \
  -Dsonar.token="$SONAR_TOKEN"
