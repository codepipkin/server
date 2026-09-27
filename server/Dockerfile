# ==========================================
# Stage 1: Download Godot Export Templates
# ==========================================
FROM alpine:3.19 AS builder

# Set the Godot version you are using
ENV GODOT_VERSION=4.3

RUN apk add --no-cache wget unzip

# Download the headless Linux export template
RUN wget https://github.com{GODOT_VERSION}-stable/Godot_v${GODOT_VERSION}-stable_linux_headless.x86_64.zip \
    && unzip Godot_v${GODOT_VERSION}-stable_linux_headless.x86_64.zip \
    && mv Godot_v${GODOT_VERSION}-stable_linux_headless.x86_64 /godot-server \
    && chmod +x /godot-server

# ==========================================
# Stage 2: Final Light Running Environment
# ==========================================
FROM ubuntu:22.04

# Install minimal certificates for secure websocket requirements
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user for security
RUN useradd -m godot
USER godot
WORKDIR /home/godot

# Copy the headless binary from the builder stage
COPY --from=builder /godot-server ./godot-server

# Copy your exported Godot server PCK file (see export steps below)
COPY --chown=godot:godot ./export/server.pck ./server.pck

# Expose the WebSocket port (matching your GDScript PORT variable)
EXPOSE 8080

# Run Godot in headless mode pointing to your game package
ENTRYPOINT ["./godot-server", "--headless", "--main-pack", "server.pck"]
