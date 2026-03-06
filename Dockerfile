# -------- Stage 1 : Build --------
FROM maven:3.9.6-eclipse-temurin-17 AS builder

WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# -------- Stage 2 : Runtime --------
FROM tomcat:9-jdk17

# remove default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# copy WAR file
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
