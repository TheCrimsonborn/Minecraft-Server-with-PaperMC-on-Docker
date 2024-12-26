# Minecraft Server with PaperMC on Docker

This project sets up a lightweight, scalable Minecraft server using PaperMC and Docker. It uses an Alpine Linux base image and automates server configuration for a smooth experience.

## Features

- **Lightweight:** Based on Alpine Linux for minimal image size.
- **PaperMC:** High-performance Minecraft server software.
- **Dockerized:** Easy setup and deployment with Docker.
- **Volume Support:** Persistent data storage with Docker volumes.
- **Automatic EULA Acceptance:** Ensures compliance with Minecraft's terms of service.

## Prerequisites

- [Docker](https://www.docker.com/) installed on your system.
- Basic knowledge of Docker CLI or a compatible GUI tool.

## File Structure

```plaintext
.
├── Dockerfile           # Defines the Minecraft server image
├── docker-compose.yml   # Simplifies multi-container Docker application setup
```

## Quick Start

### Step 1: Clone the Repository

```bash
git clone https://github.com/TheCrimsonborn/Minecraft-Server-with-PaperMC-on-Docker.git 
cd Minecraft-Server-with-PaperMC-on-Docker
```

### Step 2: Build and Start the Container

Using Docker Compose:

```bash
docker-compose up -d
```

This will:
- Build the Docker image using the provided `Dockerfile`.
- Start a container exposing the default Minecraft server port (`25565`).

### Step 3: Verify the Server

Check the container logs to ensure the server is running:

```bash
docker logs <container-name>
```

Replace `<container-name>` with the name of your Minecraft server container (e.g., `minecraft_minecraft_1`).

### Step 4: Connect to the Server

Open Minecraft and connect to the server using the host's IP address and the default port:

```
<host-ip>:25565
```

## Customization

### Environment Variables

You can modify the Minecraft version and PaperMC build in the `Dockerfile`:

```dockerfile
ENV MINECRAFT_VERSION=1.20.1 \
    PAPER_BUILD=latest
```

### Resource Allocation

Adjust the memory limits in the `CMD` instruction of the `Dockerfile`:

```dockerfile
CMD ["java", "-Xmx1024M", "-Xms1024M", "-jar", "paperclip.jar", "--nogui"]
```

### Persistent Storage

The `docker-compose.yml` mounts a volume for server data:

```yaml
volumes:
  - ./data:/minecraft-server
```

The `./data` directory will store server data (world files, configuration, etc.).

### Ports

The server exposes the default Minecraft port (`25565`). Update the `docker-compose.yml` to use a custom port if needed:

```yaml
ports:
  - "<custom-port>:25565"
```

## Troubleshooting

- **Container doesn't start:** Check the logs for errors using `docker logs <container-name>`.
- **Unable to connect to server:** Ensure the correct IP and port are used, and confirm your firewall allows traffic on port `25565`.
- **Volume issues:** Make sure the `./data` directory is writable.

## Stopping the Server

To stop the server gracefully:

```bash
docker-compose down
```

This will stop the container but keep the persistent data in the `./data` directory.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

---

Enjoy your Minecraft server! If you encounter issues or have suggestions, feel free to open an issue or contribute to the project.
