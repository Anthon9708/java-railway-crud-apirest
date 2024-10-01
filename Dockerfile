FROM eclipse-temurin:21-jdk as build

WORKDIR /app
COPY . /app

RUN chmod +x mvnw
RUN ./mvnw package -DskipTests
RUN mv target/*.jar app.jar

FROM eclipse-temurin:21-jre

ARG PORT=8080
ENV PORT=${PORT}

RUN useradd -ms /bin/bash runtime
USER runtime

WORKDIR /home/runtime

COPY --from=build /app/app.jar .

EXPOSE ${PORT}

ENTRYPOINT ["java", "-Dserver.port=${PORT}", "-jar", "app.jar"]
