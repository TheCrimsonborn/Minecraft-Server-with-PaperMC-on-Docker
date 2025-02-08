
# Minecraft Server with PaperMC on Docker

This project sets up a lightweight, scalable Minecraft server using PaperMC and Docker. It leverages modern containerization practices for a seamless and portable server experience.

## Features

- **Lightweight:** Based on Alpine Linux for minimal image size and resource usage.
- **PaperMC:** High-performance and customizable Minecraft server software.
- **Dockerized Deployment:** Simplifies setup with Docker and Docker Compose.
- **Persistent Data:** Ensures world data and configurations are safely stored.
- **Automatic Restarts:** Configured to automatically restart unless stopped manually.
- **Customizable Configurations:** Easily adjust server settings such as memory allocation, ports, and versioning.

## Prerequisites

- [Docker](https://www.docker.com/) and [Docker Compose](https://docs.docker.com/compose/) installed.
- Basic familiarity with command-line operations.

## File Overview

```plaintext
.
├── Dockerfile           # Defines the custom image for the Minecraft server
├── docker-compose.yml   # Orchestrates container deployment
```

### Dockerfile Highlights

```dockerfile
# Use Eclipse Temurin's Alpine-based JRE image
FROM eclipse-temurin:21-jre-alpine

# Set environment variables
ENV MINECRAFT_VERSION=1.21.3 \
    PAPER_BUILD=82

# Create a directory for the server
WORKDIR /minecraft-server/data

# Download the Paper server jar dynamically
RUN apk add --no-cache curl bash && \
    curl -o paperclip.jar "https://api.papermc.io/v2/projects/paper/versions/${MINECRAFT_VERSION}/builds/${PAPER_BUILD}/downloads/paper-${MINECRAFT_VERSION}-${PAPER_BUILD}.jar"

# Automatically accept EULA
RUN echo "eula=true" > eula.txt

# Expose the default Minecraft server port
EXPOSE 25565

# Start the server with optimized flags
CMD ["java", "-Xms16896M", "-Xmx16896M", "--add-modules=jdk.incubator.vector", "-XX:+UseG1GC", "-XX:+ParallelRefProcEnabled", "-XX:MaxGCPauseMillis=200", "-XX:+UnlockExperimentalVMOptions", "-XX:+DisableExplicitGC", "-XX:+AlwaysPreTouch", "-XX:G1HeapWastePercent=5", "-XX:G1MixedGCCountTarget=4", "-XX:InitiatingHeapOccupancyPercent=15", "-XX:G1MixedGCLiveThresholdPercent=90", "-XX:G1RSetUpdatingPauseTimePercent=5", "-XX:SurvivorRatio=32", "-XX:+PerfDisableSharedMem", "-XX:MaxTenuringThreshold=1", "-Dusing.aikars.flags=https://mcflags.emc.gs", "-Daikars.new.flags=true", "-XX:G1NewSizePercent=40", "-XX:G1MaxNewSizePercent=50", "-XX:G1HeapRegionSize=16M", "-XX:G1ReservePercent=15", "-jar", "paperclip.jar", "--nogui"]
```

### docker-compose.yml Highlights

```yaml
services:
  minecraft:
    build: .
    container_name: minecraft
    ports:
      - "25565:25565"
    volumes:
      - minecraft:/minecraft-server/data
    restart: unless-stopped

volumes:
  minecraft:

```

## Getting Started

### Step 1: Clone the Repository

```bash
git clone https://github.com/TheCrimsonborn/Minecraft-Server-with-PaperMC-on-Docker/tree/main
cd Minecraft-Server-with-PaperMC-on-Docker
```

### Step 2: Build and Deploy

Build the Docker image and start the server using Docker Compose:

```bash
docker-compose up -d
```

### Step 3: Verify and Connect

- Check logs: `docker logs minecraft`
- Connect via Minecraft: `<your-ip>:25565`

## Customization Options

### Memory Allocation

Modify the `-Xmx` and `-Xms` flags in the `Dockerfile` to allocate desired memory.

### Version Control

Update `MINECRAFT_VERSION` and `PAPER_BUILD` in the Dockerfile to use specific versions.

### Persistent Storage

The server's data is stored in the `minecraft` volume defined in `docker-compose.yml`.

### Networking

Customize the ports in `docker-compose.yml`:

```yaml
ports:
  - "<custom-port>:25565"
```

## Troubleshooting

- **Connection Issues:** Ensure ports are open and the correct IP is used.
- **Volume Problems:** Verify write permissions for the volume mount directory.

## Stopping the Server

Gracefully stop the server and containers:

```bash
docker-compose down
```

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
