#!/bin/bash
# FoxHT - Stop all servers

echo "=== Stopping FoxHT Servers ==="
pkill -f login-server 2>/dev/null && echo "  login-server stopped" || echo "  login-server not running"
pkill -f char-server 2>/dev/null && echo "  char-server stopped" || echo "  char-server not running"
pkill -f map-server 2>/dev/null && echo "  map-server stopped" || echo "  map-server not running"
echo "Done."
