# OpenCode Docker

Containerized development environment with [OpenCode](https://opencode.ai) WebUI and multi-language toolchain.

[![Docker Hub](https://img.shields.io/docker/v/lietxia/opencode/latest?label=Docker%20Hub\&logo=docker)](https://hub.docker.com/r/lietxia/opencode)
[![GHCR](https://img.shields.io/badge/GHCR-lietxia%2Fopencode-blue?logo=github)](https://github.com/lietxia/opencode-docker/pkgs/container/opencode)

## Quick Start

```bash
# Clone
git clone https://github.com/lietxia/opencode-docker.git
cd opencode-docker

# Start
docker compose up -d
```

Open http://localhost:4096

| | Default |
|---|---|
| Username | \`ubuntu\` |
| Password | \`ubuntu\` |

## Container Registry

| Registry | Image |
|---|---|
| Docker Hub | \`docker pull lietxia/opencode:latest\` |
| GitHub Container Registry | \`docker pull ghcr.io/lietxia/opencode:latest\` |

### Pull & Run directly

```bash
docker run -d   -p 4096:4096   -p 9999:9999   -p 8888:8888   -v \$(pwd)/workspace:/workspace   --name opencode-webui   lietxia/opencode:latest
```

## Included Tools

| Tool | Version | Description |
|---|---|---|
| **OpenCode** | latest | AI-powered code editor |
| **Python** | 3.13 | Data science \& scripting |
| **Node.js** | LTS | JavaScript/TypeScript runtime |
| **Bun** | latest | High-performance JS runtime |
| **Go** | 1.23.5 | Systems programming |
| **Rust** | latest | Systems programming |
| **Java** | OpenJDK 21 LTS | Enterprise platform |
| **Maven** | repo version | Java build tool |
| **PHP** | repo version | Web development |
| **uv** | latest | Python package manager |
| **rclone** | repo version | Cloud storage sync |
| **magic-wormhole** | repo version | Secure file transfer |

## Ports

| Port | Service |
|---|---|
| 4096 | OpenCode WebUI |
| 9999 | Reserved |
| 8888 | Reserved |

## Environment Variables

| Variable | Description | Default |
|---|---|---|
| \`OPENCODE_SERVER_USERNAME\` | WebUI login username | \`ubuntu\` |
| \`OPENCODE_SERVER_PASSWORD\` | WebUI login password | \`ubuntu\` |
| \`OPENCODE_PORT\` | WebUI listen port | \`4096\` |
| \`OPENCODE_HOSTNAME\` | WebUI bind address | \`0.0.0.0\` |

## Data Persistence

| Host path | Container path | Purpose |
|---|---|---|
| \`./workspace/\` | \`/workspace/\` | Project files |

## Build from Source

```bash
# Default tag
./build.sh

# Custom tag
./build.sh lietxia/opencode:v1.0
```

Push to registry:

```bash
# Docker Hub
docker push lietxia/opencode:latest

# GHCR
docker push ghcr.io/lietxia/opencode:latest
```

## Shell Access

```bash
docker exec -it opencode-webui bash
```

## Verify Installation

```bash
docker exec opencode-webui bash -c \'
  python3 --version  &&
  node --version     &&
  go version         &&
  rustc --version    &&
  java --version     &&
  php --version
\'
```

## Project Structure

```
.
├── Dockerfile          # Image definition
├── docker-compose.yml  # Compose config (pulls from registry)
├── build.sh            # Local build script
├── README.md
└── workspace/          # Mounted work directory
```

## License

MIT
