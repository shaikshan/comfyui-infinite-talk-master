#!/usr/bin/env bash
set -e

echo "🚀 Starting ComfyUI on port 8188"

cd /workspace/ComfyUI

exec python main.py \
  --listen 0.0.0.0 \
  --port 8188







