#!/usr/bin/env bash
set -e

echo "⚡ Starting ComfyUI + VS Code"
echo "📁 Workspace: /workspace"

# Activate venv
source /workspace/venv/bin/activate

# Start VS Code in background
/workspace/scripts/start_vscode.sh &

# Start ComfyUI (foreground, keeps container alive)
/workspace/scripts/start_comfyui.sh
