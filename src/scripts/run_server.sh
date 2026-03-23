#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SRC_DIR="$ROOT_DIR"

cd "$SRC_DIR"

echo "==> Cleaning..."
make clear || true
make clean || true

echo "==> Building Swift package..."
cd "$ROOT_DIR/brick_game"
swift build

echo "==> Starting server..."
exec swift run Server
