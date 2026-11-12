#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

TAG="${1:-lietxia/opencode:latest}"
VERSION="${2:-2.2.5}"

echo "==> Building image: $TAG (opencode $VERSION)"
docker build --build-arg OPENCODE_VERSION="$VERSION" -t "$TAG" .

echo ""
echo "==> Build complete: $TAG"
echo ""
echo "Push to Docker Hub:"
echo "  docker push $TAG"
echo ""
echo "Start:"
echo "  docker compose up -d"
