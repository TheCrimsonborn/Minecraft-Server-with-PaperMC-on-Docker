# Use Eclipse Temurin's Alpine-based JRE image
FROM eclipse-temurin:21-jre-alpine

# Set environment variables
ENV MINECRAFT_VERSION=1.21.3 \
    PAPER_BUILD=82 \
    EXPORTER_VERSION=3.1.0

# Create a directory for the server
WORKDIR /minecraft-server/data

# Install dependencies
RUN apk add --no-cache wget bash

# Download PaperMC
RUN wget -O paperclip.jar "https://api.papermc.io/v2/projects/paper/versions/${MINECRAFT_VERSION}/builds/${PAPER_BUILD}/downloads/paper-${MINECRAFT_VERSION}-${PAPER_BUILD}.jar"

# Ensure plugins directory exists
RUN mkdir -p plugins/PrometheusExporter

# Download Prometheus Exporter JAR directly to plugins directory
RUN wget -O plugins/minecraft-prometheus-exporter.jar "https://github.com/sladkoff/minecraft-prometheus-exporter/releases/download/v${EXPORTER_VERSION}/minecraft-prometheus-exporter-${EXPORTER_VERSION}.jar"

# Automatically create the config.yml file with correct settings
RUN echo "host: 0.0.0.0" > plugins/PrometheusExporter/config.yml && \
    echo "port: 9940" >> plugins/PrometheusExporter/config.yml && \
    echo "enable_metrics:" >> plugins/PrometheusExporter/config.yml && \
    echo "  entities_total: true" >> plugins/PrometheusExporter/config.yml && \
    echo "  villagers_total: true" >> plugins/PrometheusExporter/config.yml && \
    echo "  loaded_chunks_total: true" >> plugins/PrometheusExporter/config.yml && \
    echo "  jvm_memory: true" >> plugins/PrometheusExporter/config.yml && \
    echo "  players_online_total: true" >> plugins/PrometheusExporter/config.yml && \
    echo "  players_total: true" >> plugins/PrometheusExporter/config.yml && \
    echo "  whitelisted_players: true" >> plugins/PrometheusExporter/config.yml && \
    echo "  tps: true" >> plugins/PrometheusExporter/config.yml && \
    echo "  world_size: true" >> plugins/PrometheusExporter/config.yml && \
    echo "  jvm_threads: true" >> plugins/PrometheusExporter/config.yml && \
    echo "  jvm_gc: true" >> plugins/PrometheusExporter/config.yml && \
    echo "  tick_duration_median: true" >> plugins/PrometheusExporter/config.yml && \
    echo "  tick_duration_average: true" >> plugins/PrometheusExporter/config.yml && \
    echo "  tick_duration_min: true" >> plugins/PrometheusExporter/config.yml && \
    echo "  tick_duration_max: true" >> plugins/PrometheusExporter/config.yml && \
    echo "  player_online: true" >> plugins/PrometheusExporter/config.yml && \
    echo "  player_statistic: true" >> plugins/PrometheusExporter/config.yml

# Automatically accept EULA
RUN echo "eula=true" > eula.txt

# Expose Minecraft & Prometheus Exporter port
EXPOSE 25565 9940

# Define volume for persistent data storage
VOLUME ["/minecraft-server/data"]

# Start the server with optimized flags
CMD ["java", "-Xms8192M", "-Xmx8192M", "--add-modules=jdk.incubator.vector", "-XX:+UseG1GC", "-XX:+ParallelRefProcEnabled", "-XX:MaxGCPauseMillis=200", "-XX:+UnlockExperimentalVMOptions", "-XX:+DisableExplicitGC", "-XX:+AlwaysPreTouch", "-XX:G1HeapWastePercent=5", "-XX:G1MixedGCCountTarget=4", "-XX:InitiatingHeapOccupancyPercent=15", "-XX:G1MixedGCLiveThresholdPercent=90", "-XX:G1RSetUpdatingPauseTimePercent=5", "-XX:SurvivorRatio=32", "-XX:+PerfDisableSharedMem", "-XX:MaxTenuringThreshold=1", "-Dusing.aikars.flags=https://mcflags.emc.gs", "-Daikars.new.flags=true", "-XX:G1NewSizePercent=40", "-XX:G1MaxNewSizePercent=50", "-XX:G1HeapRegionSize=16M", "-XX:G1ReservePercent=15", "-jar", "paperclip.jar", "--nogui"]
