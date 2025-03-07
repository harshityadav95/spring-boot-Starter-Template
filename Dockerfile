# Use an official Maven image to build the project
FROM maven:latest AS build

# Set the working directory in the container
WORKDIR /app

# Copy the pom.xml file and download dependencies
COPY pom.xml /app/
RUN mvn dependency:go-offline

# Copy the source code into the container
COPY src /app/src

# Package the application
RUN mvn package -DskipTests

# Use an official OpenJDK runtime as a parent image
FROM openjdk:21-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the packaged jar file from the build stage
COPY --from=build /app/target/demo-0.0.1-SNAPSHOT.jar /app/demo.jar

# Expose the port the application runs on
EXPOSE 8080

# Run the jar file
ENTRYPOINT ["java", "-jar", "demo.jar"]