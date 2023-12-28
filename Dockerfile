FROM maven:3.6.3-openjdk-11 AS builder

WORKDIR /app

# Copier les fichiers POM et source
COPY pom.xml .
COPY src ./src

# Construire le projet et copier le fichier JAR dans le répertoire /app/target
RUN mvn clean package -DskipTests && \
    echo "Maven build successful" && \
    ls -la /app && \
    ls -la /app/target && \
    ls -la /app/target/*.jar
# Deuxième étape : exécuter l'application avec Java
FROM adoptopenjdk:11-jre-hotspot

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier le fichier JAR de l'application dans l'image à partir de l'étape de construction
COPY --from=builder /app/target/config-server.jar ./app.jar

# Exposer le port sur lequel l'application s'exécute
EXPOSE 8888

# Commande à exécuter lorsque le conteneur démarre
CMD ["java", "-jar", "app.jar"]
