# ==========================================
# Stage 1: Download Godot 4.5 Export Templates
# ==========================================
FROM alpine:3.19 AS builder

# Setting to the stable 4.5 production release
ENV GODOT_VERSION=4.5.2

RUN apk add --no-cache wget unzip

# Downloads the official 4.5.2 export templates package
RUN wget https://github.com{GODOT_VERSION}-stable/Godot_v${GODOT_VERSION}-stable_export_templates.tpz \
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

RUN useradd -m godot
USER godot
WORKDIR /home/godot

COPY --from=builder /godot-server ./godot-server
COPY --chown=godot:godot ./export/server.pck ./server.pck

EXPOSE 8080

ENTRYPOINT ["./godot-server", "--headless", "--main-pack", "server.pck"]
