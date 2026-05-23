FROM eclipse-temurin:17-jre

WORKDIR /app
COPY target/*.jar /app/application.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/application.jar"]
