# ====== BUILD STAGE ======
FROM maven:3.9.6-eclipse-temurin-17 AS builder

WORKDIR /app

COPY pom.xml .
COPY mvnw .
COPY mvnw.cmd .
# COPY .mvn .mvn

# RUN ./mvnw dependency:go-offline -B

COPY src ./src

# RUN ./mvnw clean package -DskipTests
RUN mvn clean install

# ====== RUNTIME STAGE ======
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

RUN apk --no-cache del sudo || true && \
    rm -f /bin/su /usr/bin/sudo || true

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=builder /app/target/*.jar app.jar

RUN chown appuser:appgroup /app/app.jar && \
    chmod 500 /app/app.jar && \
    chmod 555 /app

USER appuser

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]