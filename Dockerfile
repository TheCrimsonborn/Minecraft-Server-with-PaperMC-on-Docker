# Use the lightweight Alpine Linux image
FROM alpine:latest

# Install required dependencies
RUN apk add --no-cache openjdk17 curl bash nano vi vim

# Set environment variables
ENV MINECRAFT_VERSION=1.20.1 \
    PAPER_BUILD=latest

# Create a directory for the server
WORKDIR /minecraft-server

# Download the Paper server jar
RUN curl -o paperclip.jar "https://api.papermc.io/v2/projects/paper/versions/$MINECRAFT_VERSION/builds/$PAPER_BUILD/downloads/paper-$MINECRAFT_VERSION-$PAPER_BUILD.jar"

# Automatically accept EULA
RUN echo "eula=true" > eula.txt

# Expose the default Minecraft server port
EXPOSE 25565

# Start the server
CMD ["java", "-Xmx1024M", "-Xms1024M", "-jar", "paperclip.jar", "--nogui"]