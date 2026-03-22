#!/bin/bash
# FoxHT - Restart all servers (useful after deploying changes)
# Usage: ./restart.sh [rathena_path]

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
RATHENA_PATH="${1:-$HOME/rathena}"

echo "=== Restarting FoxHT Servers ==="
"$SCRIPT_DIR/stop.sh"
sleep 3
"$SCRIPT_DIR/start.sh" "$RATHENA_PATH"
