# Deployment Guide: JAR, WAR, Maven, Gradle, and Node

## 1. Deploy a Normal Runnable JAR

A normal runnable Java JAR usually runs like this:

```bash
java -jar application.jar
```

For a real server, create a systemd service:

```bash
bash scripts/install-systemd-service.sh demo-app
```

Then deploy:

```bash
bash scripts/deploy-jar-war.sh target/normal-java-app.jar systemd-jar ubuntu YOUR_SERVER_IP
```

The GitHub Actions workflow does the same idea:

```text
copy JAR to /opt/demo-app/demo-app.jar
restart demo-app service
```

## 2. Deploy a WAR to Tomcat

A WAR is commonly deployed to Tomcat.

The target path is usually:

```text
/opt/tomcat/webapps/application.war
```

Deploy:

```bash
bash scripts/deploy-jar-war.sh application.war tomcat-war ubuntu YOUR_SERVER_IP
```

Tomcat extracts the WAR and serves the application.

## 3. Deploy an External JAR or WAR

The workflow `.github/workflows/deploy-external-artifact.yml` lets you manually deploy a JAR or WAR from a URL.

Go to:

```text
GitHub > Actions > Deploy external JAR/WAR > Run workflow
```

Provide:

```text
artifact_url
artifact_type: jar or war
deploy_target: systemd-jar or tomcat-war
```

For a more complete existing-JAR pipeline with inspection, smoke testing, reports, and deployment, use:

```text
.github/workflows/jar-first-ci-cd.yml
```

## 4. What If the Project Is Node?

Node projects do not produce JAR or WAR files. They usually use:

```bash
npm ci
npm test
npm run build
```

Deployment options:

- Copy build output to a web server.
- Build and run a Docker image.
- Deploy to platforms like AWS, Azure, Render, Railway, or Vercel.

The detection script runs Node commands if `package.json` exists.

## 5. What If the Project Is Maven?

Maven projects have:

```text
pom.xml
```

Common commands:

```bash
mvn clean test
mvn clean verify
mvn clean package
```

Output:

```text
target/*.jar
target/*.war
```

## 6. What If the Project Is Gradle?

Gradle projects have:

```text
build.gradle
build.gradle.kts
```

Common commands:

```bash
./gradlew clean test build
```

Output:

```text
build/libs/*.jar
build/libs/*.war
```

## 7. Required Server Setup for GitHub Actions Deployment

Your server needs:

- Java installed for JAR deployment.
- Tomcat installed for WAR deployment.
- A deployment user, such as `ubuntu`.
- SSH access from GitHub Actions.
- Correct permissions to restart services.

GitHub secrets needed:

```text
STAGING_HOST
STAGING_USER
STAGING_SSH_PRIVATE_KEY
```

## 8. Real Production Note

For production, many teams prefer Docker or Kubernetes deployment instead of directly copying JAR or WAR files. This project includes a `Dockerfile` so you can extend it later.
