# Use Eclipse Temurin's Alpine-based JRE image
FROM eclipse-temurin:21-jre-alpine

# Set environment variables
ENV MINECRAFT_VERSION=1.21.3 \
    PAPER_BUILD=82

# Create a directory for the server
WORKDIR /minecraft-server

# Download the Paper server jar dynamically
RUN apk add --no-cache curl bash && \
    curl -o paperclip.jar "https://api.papermc.io/v2/projects/paper/versions/${MINECRAFT_VERSION}/builds/${PAPER_BUILD}/downloads/paper-${MINECRAFT_VERSION}-${PAPER_BUILD}.jar"

# Automatically accept EULA
RUN echo "eula=true" > eula.txt

# Expose the default Minecraft server port
EXPOSE 25565

# Start the server with optimized flags
CMD ["java", "-Xms12288M", "-Xmx12288M", "--add-modules=jdk.incubator.vector", "-XX:+UseG1GC", "-XX:+ParallelRefProcEnabled", "-XX:MaxGCPauseMillis=200", "-XX:+UnlockExperimentalVMOptions", "-XX:+DisableExplicitGC", "-XX:+AlwaysPreTouch", "-jar", "paperclip.jar"]