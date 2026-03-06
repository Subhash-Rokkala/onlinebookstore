# -------- Stage 1 : Build --------
FROM maven:3.9.6-eclipse-temurin-17-alpine AS builder

WORKDIR /app
COPY . .

RUN mvn clean package -DskipTests

# -------- Stage 2 : Runtime ---------
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

COPY --from=builder /app/target/*.war app.war
COPY --from=builder /app/target/dependency/webapp-runner.jar webapp-runner.jar

EXPOSE 8080

CMD ["java","-jar","webapp-runner.jar","app.war"]
