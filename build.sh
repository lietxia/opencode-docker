#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

TAG="${1:-lietxia/opencode:latest}"

echo "==> Building image: $TAG"
docker build -t "$TAG" .

echo ""
echo "==> Build complete: $TAG"
echo ""
echo "Push to Docker Hub:"
echo "  docker push $TAG"
echo ""
echo "Run with docker compose (switch to local build first):"
echo "  # In docker-compose.yml, uncomment 'build: .' and comment 'image:'"
echo "  docker compose up -d"
