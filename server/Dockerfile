# ==========================================
# Stage 1: Download Godot 4.5.2 Export Templates
# ==========================================
FROM alpine:3.19 AS builder

ENV GODOT_VERSION=4.5.2

RUN apk add --no-cache wget unzip

RUN wget https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-stable/Godot_v${GODOT_VERSION}-stable_export_templates.tpz \
    && unzip Godot_v${GODOT_VERSION}-stable_export_templates.tpz \
    && mv templates/linux_release.x86_64 /godot-server \
    && chmod +x /godot-server

# ==========================================
# Stage 2: Final Light Running Environment
# ==========================================
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy binaries into root app workspace to prevent Railway permission faults
COPY --from=builder /godot-server ./godot-server
COPY ./export/server.pck ./server.pck

# Hand off port handling to Railway's execution environment
ENV PORT=8080
EXPOSE $PORT

ENTRYPOINT ["./godot-server", "--headless", "--main-pack", "server.pck"]
