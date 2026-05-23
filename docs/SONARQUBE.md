# SonarQube and SonarCloud Setup

## Option A: SonarCloud

SonarCloud is easier for GitHub projects.

1. Go to `https://sonarcloud.io`.
2. Sign in with GitHub.
3. Import your GitHub repository.
4. Create a token.
5. Add the token to GitHub as a repository secret named:

```text
SONAR_TOKEN
```

Update these values in `pom.xml`:

```xml
<sonar.projectKey>your-org_cicd-pipeline-demo</sonar.projectKey>
<sonar.organization>your-org</sonar.organization>
<sonar.host.url>https://sonarcloud.io</sonar.host.url>
```

## Option B: Local SonarQube

Start SonarQube locally:

```bash
docker compose -f docker-compose.sonar.yml up -d
```

Open:

```text
http://localhost:9000
```

Default login:

```text
username: admin
password: admin
```

Create a project and token, then run:

```bash
export SONAR_TOKEN="your-token"
mvn clean verify sonar:sonar -Dsonar.host.url=http://localhost:9000 -Dsonar.token=$SONAR_TOKEN
```

On Windows PowerShell:

```powershell
$env:SONAR_TOKEN="your-token"
mvn clean verify sonar:sonar -Dsonar.host.url=http://localhost:9000 -Dsonar.token=$env:SONAR_TOKEN
```

## What SonarQube Checks

SonarQube checks:

- Bugs
- Vulnerabilities
- Code smells
- Duplicated code
- Test coverage
- Maintainability
- Security hotspots

## Quality Gate

A quality gate is a pass/fail rule.

Example:

- No new critical bugs.
- Coverage must be above a required percentage.
- Duplicated code must stay below a limit.

If the quality gate fails, the CI/CD pipeline should stop before deployment.

