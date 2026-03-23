#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SRC_DIR="$ROOT_DIR"

cd "$SRC_DIR"

echo "==> Cleaning..."
make clear || true
make clean || true

echo "==> Building console..."
make console

echo "==> Starting console..."
exec ./build_cli/console
