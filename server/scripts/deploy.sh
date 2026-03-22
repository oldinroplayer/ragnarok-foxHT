#!/bin/bash
# FoxHT - Deploy customizations to rAthena server
# Usage: ./deploy.sh [rathena_path]
#
# This script copies all FoxHT customizations into a rAthena installation.
# It does NOT modify base rAthena files — only adds/overwrites import configs and custom NPCs.

RATHENA_PATH="${1:-$HOME/rathena}"

if [ ! -d "$RATHENA_PATH" ]; then
    echo "Error: rAthena not found at $RATHENA_PATH"
    echo "Usage: ./deploy.sh /path/to/rathena"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "=== FoxHT Deploy ==="
echo "Source: $SCRIPT_DIR"
echo "Target: $RATHENA_PATH"
echo ""

# Copy config overrides
echo "[1/3] Copying config overrides..."
cp "$SCRIPT_DIR/conf/import/battle_conf.txt" "$RATHENA_PATH/conf/import/"
cp "$SCRIPT_DIR/conf/import/char_conf.txt" "$RATHENA_PATH/conf/import/"
cp "$SCRIPT_DIR/conf/import/login_conf.txt" "$RATHENA_PATH/conf/import/"
cp "$SCRIPT_DIR/conf/import/map_conf.txt" "$RATHENA_PATH/conf/import/"
cp "$SCRIPT_DIR/conf/import/inter_conf.txt" "$RATHENA_PATH/conf/import/"
cp "$SCRIPT_DIR/conf/import/groups.yml" "$RATHENA_PATH/conf/import/"

# Copy custom NPC scripts
echo "[2/3] Copying custom NPC scripts..."
cp "$SCRIPT_DIR/npc/custom/pvp_warper.txt" "$RATHENA_PATH/npc/custom/"
cp "$SCRIPT_DIR/npc/custom/instance_warper.txt" "$RATHENA_PATH/npc/custom/"
cp "$SCRIPT_DIR/npc/custom/command_guide.txt" "$RATHENA_PATH/npc/custom/"
cp "$SCRIPT_DIR/npc/custom/login_message.txt" "$RATHENA_PATH/npc/custom/"
cp "$SCRIPT_DIR/npc/scripts_custom.conf" "$RATHENA_PATH/npc/scripts_custom.conf"

# Done
echo "[3/3] Done!"
echo ""
echo "Next steps:"
echo "  1. Verify char_ip and map_ip in conf/import/ match your server's public IP"
echo "  2. Compile: ./configure --enable-prere=yes --enable-packetver=20200218 && make clean && make server -j1"
echo "  3. Restart the servers"
