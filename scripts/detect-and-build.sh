#!/usr/bin/env bash
set -euo pipefail

echo "Detecting project type..."

if [[ -f "pom.xml" ]]; then
  echo "Maven project detected"
  mvn --batch-mode clean verify
elif [[ -f "build.gradle" || -f "build.gradle.kts" ]]; then
  echo "Gradle project detected"
  if [[ -f "./gradlew" ]]; then
    chmod +x ./gradlew
    ./gradlew clean test build
  else
    gradle clean test build
  fi
elif [[ -f "package.json" ]]; then
  echo "Node project detected"
  if [[ -f "package-lock.json" ]]; then
    npm ci
  else
    npm install
  fi

  npm run lint --if-present
  npm test --if-present
  npm run build --if-present
else
  echo "No supported project file found."
  echo "Expected one of: pom.xml, build.gradle, build.gradle.kts, package.json"
  exit 1
fi
