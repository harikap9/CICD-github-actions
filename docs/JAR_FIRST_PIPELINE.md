# JAR-First CI/CD Pipeline

This document covers the exact case where someone gives you an already built normal runnable JAR file and asks you to deploy it through CI/CD.

The workflow is:

```text
Receive JAR URL
    |
Download JAR in GitHub Actions
    |
Validate that the file exists and is not empty
    |
Inspect JAR contents and manifest
    |
Optionally start the JAR and run a smoke test against /health
    |
Upload reports whether the check passes or fails
    |
Deploy the JAR to a Linux server
    |
Restart the systemd service
```

## Workflow File

Use:

```text
.github/workflows/jar-first-ci-cd.yml
```

Run it manually from:

```text
GitHub > Actions > CI/CD - Existing JAR Artifact > Run workflow
```

Inputs:

```text
jar_url: URL where the JAR can be downloaded
app_name: service name on the server
run_smoke_test: true or false
```

## What Reports Are Generated?

The pipeline uploads:

```text
jar-inspection-reports
jar-smoke-test-reports
```

These reports are uploaded with:

```yaml
if: always()
```

That means reports are available even if the smoke test fails.

## What Can Be Checked From a JAR Alone?

From only a JAR, you can check:

- The artifact exists.
- The artifact is not empty.
- The manifest is readable.
- The expected files/classes are present.
- The application starts.
- A health endpoint responds, if the JAR exposes one.
- Deployment succeeds.

## What Cannot Be Fully Checked From a JAR Alone?

SonarQube quality analysis should run on source code, not only on a final JAR.

That means:

- If you have source code, use `.github/workflows/ci-cd.yml`.
- If you only have a JAR, use `.github/workflows/jar-first-ci-cd.yml`.
- If you only have a WAR, use `.github/workflows/deploy-external-artifact.yml`.

## How Spring Boot Fits Later

Spring Boot is not the base assumption for this project. It is only another type of runnable JAR someone may give you later.

For a Spring Boot JAR, the smoke-test endpoint is commonly:

```text
/actuator/health
```

For this normal Java sample JAR, the smoke-test endpoint is:

```text
/health
```

## How Node Fits

Node applications normally do not create JAR or WAR files. They use:

```bash
npm ci
npm test
npm run build
```

Then they are deployed as build output, server processes, or Docker images.

If someone gives you a Node project, use:

```text
.github/workflows/detect-build.yml
```

If someone gives you a JAR, treat it as a Java artifact.
