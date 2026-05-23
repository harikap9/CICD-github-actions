# End-to-End CI/CD Pipeline Project With GitHub Actions and SonarQube

This project is a complete beginner-friendly implementation of a CI/CD pipeline.
It supports two practical paths:

1. Start from source code, build a normal runnable Java JAR, test it, scan it with SonarQube, package it, and deploy it.
2. Start from an already available JAR file, inspect it, smoke-test it, upload reports, and deploy it.

## What You Will Learn

- How a CI/CD pipeline works from scratch.
- How to build a normal runnable Java JAR using Maven.
- How to run unit tests in GitHub Actions.
- How to publish test and coverage reports whether tests pass or fail.
- How to integrate SonarQube or SonarCloud quality checks.
- How to deploy a JAR file to a Linux systemd service.
- How to deploy a WAR file to Tomcat.
- How to detect and build Maven, Gradle, or Node projects.

## Project Structure

```text
.
├── .github/workflows/
│   ├── ci-cd.yml
│   ├── jar-first-ci-cd.yml
│   ├── deploy-external-artifact.yml
│   └── detect-build.yml
├── docs/
│   ├── BEGINNER_GUIDE.md
│   ├── DEPLOYMENT.md
│   └── SONARQUBE.md
├── scripts/
│   ├── deploy-jar-war.sh
│   ├── detect-and-build.sh
│   ├── install-systemd-service.sh
│   └── local-sonar-scan.sh
├── src/main/java/com/example/cicd/
├── src/test/java/com/example/cicd/
├── Dockerfile
├── docker-compose.sonar.yml
└── pom.xml
```

## CI/CD Stages for Source Code

The main workflow is in `.github/workflows/ci-cd.yml`.

1. `validate`: checks that the Maven project is valid.
2. `test`: runs unit tests and coverage.
3. `sonarqube`: sends code quality data to SonarQube or SonarCloud.
4. `package`: creates the final JAR artifact.
5. `docker`: builds a Docker image.
6. `deploy-staging`: copies the JAR to a staging server and restarts the service.

## CI/CD Stages for an Existing JAR

Use `.github/workflows/jar-first-ci-cd.yml` when someone gives you a ready-made JAR file.

1. `collect-artifact`: downloads the JAR.
2. `artifact-quality-checks`: inspects JAR contents and manifest.
3. `smoke-test`: starts the JAR and calls the health endpoint.
4. `deploy-staging`: copies the JAR to a server and restarts the systemd service.

## Run Locally

Install Java 17 and Maven, then run:

```bash
mvn clean verify
```

Start the application:

```bash
mvn spring-boot:run
```

Open:

```text
http://localhost:8080
```

## Reports

After running tests, reports are generated here:

```text
target/surefire-reports/
target/site/jacoco/index.html
```

In GitHub Actions, reports are uploaded using `if: always()`, so they are uploaded even if tests fail.

## Required GitHub Secrets

Add these in GitHub:

`Repository > Settings > Secrets and variables > Actions > New repository secret`

```text
SONAR_TOKEN
STAGING_HOST
STAGING_USER
STAGING_SSH_PRIVATE_KEY
```

## Documentation

Start here:

- [Beginner guide](docs/BEGINNER_GUIDE.md)
- [JAR-first pipeline](docs/JAR_FIRST_PIPELINE.md)
- [SonarQube setup](docs/SONARQUBE.md)
- [Deployment guide](docs/DEPLOYMENT.md)
