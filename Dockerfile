# ---------- Stage 1 : Build ----------
FROM maven:3.9.6-eclipse-temurin-17 AS builder

WORKDIR /app

# Copy project files
COPY . .

# Build the application
RUN mvn clean package -DskipTests


# ---------- Stage 2 : Runtime ----------
FROM openjdk:17-jdk-slim

WORKDIR /app

# Copy only the built jar from builder stage
COPY --from=builder /app/target/*.jar app.jar

# Expose application port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java","-jar","app.jar"]
