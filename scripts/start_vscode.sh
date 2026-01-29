#!/usr/bin/env bash
set -e

echo "🧠 Starting VS Code (code-server) on port 8888"

exec code-server \
  --bind-addr 0.0.0.0:8888 \
  --auth none \
  /workspace
