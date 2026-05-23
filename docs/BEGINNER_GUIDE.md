# Beginner Guide: CI/CD From Scratch

## 1. What Is CI/CD?

CI/CD means Continuous Integration and Continuous Deployment or Delivery.

Continuous Integration means every code change is automatically checked. The pipeline builds the project, runs tests, creates reports, and checks code quality.

Continuous Deployment means the successful build can be automatically deployed to a server.

## 2. What This Project Does

This project supports two real-world situations.

Situation 1: you have source code. GitHub Actions builds the JAR, runs tests, scans with SonarQube, and deploys.

Situation 2: someone gives you an already built JAR. GitHub Actions downloads the JAR, inspects it, smoke-tests it, uploads reports, and deploys.

The pipeline flow is:

```text
Developer pushes code
        ↓
GitHub Actions starts
        ↓
Validate project
        ↓
Run unit tests and coverage
        ↓
Upload test reports even on failure
        ↓
Run SonarQube code quality scan
        ↓
Build JAR file
        ↓
Build Docker image
        ↓
Deploy to staging server
```

The JAR-first flow is:

```text
Someone provides a JAR URL
        ↓
GitHub Actions downloads the JAR
        ↓
JAR contents and manifest are inspected
        ↓
JAR is started for a smoke test
        ↓
Reports are uploaded even on failure
        ↓
JAR is deployed to staging
```

## 3. Important Files

`pom.xml`

This is the Maven build file. It defines dependencies, plugins, Java version, testing, coverage, and SonarQube properties.

`.github/workflows/ci-cd.yml`

This is the main source-code pipeline.

`.github/workflows/jar-first-ci-cd.yml`

This is the pipeline for an already available JAR file.

`src/main/java`

This contains application code.

`src/test/java`

This contains unit tests.

`scripts/detect-and-build.sh`

This script detects Maven, Gradle, or Node projects and runs the correct commands.

## 4. Local Setup

Install these tools:

- Java 17
- Maven
- Git
- Docker Desktop, optional but useful

Check versions:

```bash
java -version
mvn -version
git --version
docker --version
```

## 5. Build the JAR Locally

Run:

```bash
mvn clean package
```

The JAR will be created in:

```text
target/normal-java-app.jar
```

## 6. Run Unit Tests

Run:

```bash
mvn test
```

Test reports are generated in:

```text
target/surefire-reports/
```

## 7. Run Tests With Coverage

Run:

```bash
mvn clean verify
```

Coverage report:

```text
target/site/jacoco/index.html
```

## 8. Push to GitHub

Create a new GitHub repository, then run:

```bash
git init
git add .
git commit -m "Add CI/CD pipeline demo"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
git push -u origin main
```

After pushing, go to:

```text
GitHub repository > Actions
```

You should see the pipeline running.

## 9. Where to See Reports in GitHub Actions

Open the workflow run, then scroll to the `Artifacts` section.

You should see:

```text
unit-test-reports
jacoco-coverage-report
jar-inspection-reports
jar-smoke-test-reports
```

These are uploaded even when tests fail because the workflow uses:

```yaml
if: always()
```

## 10. How the Pipeline Decides Pass or Fail

The pipeline fails if:

- Maven validation fails.
- Unit tests fail.
- Coverage check fails.
- SonarQube quality gate fails.
- Packaging fails.
- Deployment command fails.

For real companies, this is important because bad code should not reach production.

## 11. Maven, Gradle, and Node Build Commands

Maven normal Java JAR:

```bash
mvn clean verify
mvn clean package
java -jar target/normal-java-app.jar
```

Gradle Java project:

```bash
./gradlew clean test build
```

Node:

```bash
npm ci
npm test
npm run build
```

The workflow `.github/workflows/detect-build.yml` uses `scripts/detect-and-build.sh` to choose the right command automatically.

## 12. Important Clarification About Node and JAR/WAR

Node applications normally do not produce JAR or WAR files. Node projects usually run with `npm` and are deployed as static build files, server processes, or Docker images.

JAR and WAR are Java artifact formats.

So this project supports:

- Java source code to JAR through Maven.
- Existing JAR deployment.
- Existing WAR deployment to Tomcat.
- Node source code build using `npm`.

That makes the implementation flexible without mixing incompatible artifact types.
