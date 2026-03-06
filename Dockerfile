# ---------- Stage 1 : Build ----------
FROM maven:3.9.6-eclipse-temurin-17-alpine AS builder

WORKDIR /app

COPY . .

RUN mvn clean package -DskipTests


# ---------- Stage 2 : Prepare Tomcat ----------
FROM tomcat:9.0-jdk17-temurin

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war


# ---------- Stage 3 : Distroless Runtime ----------
FROM gcr.io/distroless/java17-debian11

COPY --from=1 /usr/local/tomcat /usr/local/tomcat

EXPOSE 8080

CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]
