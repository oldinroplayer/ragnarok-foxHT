#!/bin/bash
# FoxHT - Start all servers
# Usage: ./start.sh [rathena_path]

RATHENA_PATH="${1:-$HOME/rathena}"

if [ ! -f "$RATHENA_PATH/login-server" ]; then
    echo "Error: rAthena binaries not found at $RATHENA_PATH"
    exit 1
fi

cd "$RATHENA_PATH"

echo "=== Starting FoxHT Servers ==="

echo "[1/3] Starting login-server..."
./login-server > /tmp/login.log 2>&1 &
sleep 3

echo "[2/3] Starting char-server..."
./char-server > /tmp/char.log 2>&1 &
sleep 8

echo "[3/3] Starting map-server..."
./map-server > /tmp/map.log 2>&1 &
sleep 15

# Verify
echo ""
echo "=== Status ==="
pgrep -a login-server && echo "  login-server: OK" || echo "  login-server: FAILED"
pgrep -a char-server && echo "  char-server: OK" || echo "  char-server: FAILED"
pgrep -a map-server && echo "  map-server: OK" || echo "  map-server: FAILED"
echo ""
echo "Logs: /tmp/login.log, /tmp/char.log, /tmp/map.log"
