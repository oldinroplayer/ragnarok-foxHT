# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**FoxHT** is a Ragnarok Online private server based on rAthena, configured for casual play (PVP & MVPs) among friends.

### Server Settings
- **Mode:** Pre-Renewal (classic)
- **Rates:** 100x/100x/20x (base/job/drop)
- **Max Level:** 99/70
- **Episode:** 13.2 (Satan Morroc)
- **Pre-Renewal enabled via:** `src/config/renewal.hpp` — `#define PRERE` is uncommented
- **Packet Version:** 20200218 (must match client)

## Repositories

- **GitHub repo:** https://github.com/lucasarlop/ragnarok (customizations only, NOT full rAthena)
- **Local repo:** `C:\Users\laugu\OneDrive\Documentos\GitHub\ragnarok\`
- **rAthena source (local):** `C:\Users\laugu\OneDrive\Documentos\FoxHT\`
- **rAthena source (server):** `~/rathena/`

### Repo Structure
```
ragnarok/
├── server/conf/import/    # Server config overrides
├── server/npc/custom/     # Custom NPC scripts
├── server/scripts/        # deploy.sh, start.sh, stop.sh, restart.sh
├── client/                # Client configs and fixes
├── patcher/               # Auto-update system (version.txt + patch.bat)
└── README.md
```

## Hosting

Server hosted on **AWS EC2** (São Paulo region):
- **Instance:** t3.medium (2 vCPU, 4GB RAM), Ubuntu 22.04
- **Instance ID:** i-0963d99de10c9be16
- **Elastic IP:** 56.126.166.250 (static, does not change on stop/start)
- **SSH:** `ssh -i "C:\Users\laugu\OneDrive\Documentos\ssh keys\foxht-key.pem" ubuntu@56.126.166.250`
- **rAthena path on server:** `~/rathena/`
- **AWS CLI path:** `"C:/Program Files/Amazon/AWSCLIV2/aws.exe"` (not in PATH for bash, use full path)
- **Start instance:** `"C:/Program Files/Amazon/AWSCLIV2/aws.exe" ec2 start-instances --region sa-east-1 --instance-ids i-0963d99de10c9be16`
- **Stop instance:** `"C:/Program Files/Amazon/AWSCLIV2/aws.exe" ec2 stop-instances --region sa-east-1 --instance-ids i-0963d99de10c9be16`
- **Security Group:** sg-0bfe9b7bf5145a10e (ports 22, 5121, 6121, 6900 open)
- **Elastic IP Allocation:** eipalloc-07cf8f2f8353bb5b4

### Previous Hosting (terminated)
- Oracle Cloud Free Tier instance (152.67.54.27) — terminated, had 1GB RAM issues
- AWS t3.small (i-047eed81a35184f8c) — terminated, couldn't compile map-server

## Client Setup

- **Client version:** kRO 2020-03-04 (Ragexe 20200218, pre-renewal)
- **Client location:** `C:\Users\laugu\OneDrive\Documentos\FoxHT\kRO client\`
- **Distribution folder:** `C:\Users\laugu\OneDrive\Documentos\FoxHT\FoxHT-Client\`
- **Executable:** `FoxHT.exe` (Ragexe patched with NEMO)
- **Launcher:** `FoxHT-Launcher.bat` (auto-updates from GitHub before launching)
- **Connection config:** `clientinfo.xml` (default name, no NEMO patch needed for this)
- **Important clientinfo.xml settings:** `version` must be `46`, `langtype` must be `0`
- **NEMO profile:** `C:\Users\laugu\OneDrive\Documentos\FoxHT\Nemo\FoxHT-nemoprofile.log`
- **Login background:** Custom image using 12 BMP slices (256x256) named `t_배경{row}-{col}.bmp` (row 1-3, col 1-4)
- **OpenSetup.exe:** Use this instead of Setup.exe for English settings UI

### NEMO Patches Applied
- SELECT RECOMMENDED (base patches)
- Read Data Folder First
- Note: "Always Call SelectKoreaClientInfo", "Restore Login Window", "Disable Ragexe Filename Check" are incompatible with this client

### Client File Rules (IMPORTANT)
- **"Read Data Folder First"** NEMO patch makes loose files in `data/` override GRF contents
- **DO NOT** put skill-related files (skilldescript, skillinfolist, skilltreeview, skillid) loose in `data/` — the GRF already has the correct versions. Loose renewal versions cause Gravity Error crashes when opening the skill window (ALT+S)
- **OK to put in `data/`:** clientinfo.xml, msgstringtable.txt, QuestInfo_f.lua (these need customization)

### Client File Encoding Warning
Korean folder/file names in `data/texture/` use EUC-KR encoding stored as CP1252 on Brazilian Portuguese Windows. When creating files with Korean names programmatically, decode EUC-KR bytes as CP1252.

## Auto-Update System (Launcher/Patcher)

Players use `FoxHT-Launcher.bat` instead of `FoxHT.exe` directly. The launcher:
1. Downloads `patcher/version.txt` from GitHub
2. Compares with local `_local_version.txt`
3. If versions differ, downloads and runs `patcher/patch.bat`
4. Updates local version file
5. Launches `FoxHT.exe`

### How to push an update to all players
1. Edit `patcher/patch.bat` in the GitHub repo with new fix commands
2. Increment the number in `patcher/version.txt` (e.g., `1` → `2`)
3. `git commit` and `git push`
4. Players receive the update automatically next time they open the launcher

### Patch script reference
The patch.bat can use:
- `del /q "path"` — delete problematic files
- `curl -s -f "%REPO%/path" -o "local/path"` — download files from repo
- `mkdir "path"` — create directories
- Any standard Windows batch commands

## Building (Linux — AWS Server)

```bash
cd ~/rathena
./configure --enable-prere=yes --enable-packetver=20200218
make clean && make server -j1
```

**Important:** Always use `-j1` to avoid OOM on t3.medium. The `--enable-packetver=20200218` flag is critical — must match the client version.

Produces: `login-server`, `char-server`, `map-server` in `~/rathena/`

## Building (Windows — Local Development)

Open `rAthena.sln` in Visual Studio (2022 recommended) and build the solution. Requires:
- MySQL Server 8.0+ installed
- The pre-renewal flag is set in `src/config/renewal.hpp` — if you change it, rebuild all projects
- Set PACKETVER to 20200218 in `src/custom/defines_pre.hpp`

## Database Setup

1. Create a MySQL database named `ragnarok` with user `ragnarok` / password `ragnarok`
2. Import SQL files in order:
   ```
   mysql -u ragnarok -p ragnarok < sql-files/main.sql
   mysql -u ragnarok -p ragnarok < sql-files/logs.sql
   ```
3. MySQL credentials are in `conf/inter_athena.conf` (defaults) and `conf/import/inter_conf.txt` (overrides)

## Running the Server

On the AWS instance:
```bash
cd ~/rathena
./login-server > /tmp/login.log 2>&1 &
sleep 3
./char-server > /tmp/char.log 2>&1 &
sleep 8
./map-server > /tmp/map.log 2>&1 &
```

Or use the scripts from the repo:
```bash
~/foxht/server/scripts/start.sh ~/rathena
~/foxht/server/scripts/stop.sh
~/foxht/server/scripts/restart.sh ~/rathena
```

Logs are in `/tmp/login.log`, `/tmp/char.log`, `/tmp/map.log`.

## Configuration Architecture

**Never edit the base config files directly.** All customizations go in `conf/import/` which overrides the base configs:

| File | Purpose |
|------|---------|
| `conf/import/battle_conf.txt` | Rates, drop rates, death penalty, display settings |
| `conf/import/char_conf.txt` | Server name (FoxHT), starting zeny, pincode disabled |
| `conf/import/login_conf.txt` | Account creation via `_M/_F` enabled |
| `conf/import/inter_conf.txt` | MySQL credentials |
| `conf/import/map_conf.txt` | Map server overrides |
| `conf/import/groups.yml` | Player commands (@go, @autoloot, @storage, etc.) |

Base configs are in `conf/` and `conf/battle/`. The import files are loaded last and override them.

**Important:** `char_conf.txt` and `map_conf.txt` must have the server's public IP (56.126.166.250) for external connections.

## Deploying Changes

### Server-side changes (configs, NPCs)
```bash
# On local machine
cd C:\Users\laugu\OneDrive\Documentos\GitHub\ragnarok
# Edit files in server/
git add . && git commit -m "description" && git push

# On AWS server
cd ~/foxht && git pull
./server/scripts/deploy.sh ~/rathena
./server/scripts/restart.sh ~/rathena
```

### Client-side changes (fixes for players)
```bash
# On local machine
cd C:\Users\laugu\OneDrive\Documentos\GitHub\ragnarok
# Edit patcher/patch.bat with new fix commands
# Increment number in patcher/version.txt
git add . && git commit -m "description" && git push
# Players receive automatically via launcher
```

## Key Directories

- `src/config/renewal.hpp` — Pre-renewal toggle (PRERE define)
- `conf/battle/` — Battle mechanics, drops, exp formulas
- `conf/groups.yml` + `conf/import/groups.yml` — Player permissions and @commands
- `db/pre-re/` — Pre-renewal database files (items, mobs, skills)
- `db/re/` — Renewal database files (not used)
- `npc/pre-re/` — Pre-renewal NPC scripts
- `sql-files/` — Database schema and data

## Episode Content Control

Episode 13.2 (Satan Morroc) content is controlled via NPC scripts. Maps and monsters from later episodes should be disabled in `conf/maps_athena.conf` and related NPC scripts if they appear.

## Known Issues & Notes

- **Translation:** "NO MSG" text shows in some client UI elements — msgstringtable.txt has fewer entries than original Korean version. Low priority.
- **ESC menu in Korean:** Hardcoded in executable, would need NEMO patch or Lua file replacement.
- **loginlog table:** Missing table warning in login-server log — cosmetic, doesn't affect gameplay.
- **Elastic IP cost:** Elastic IP is free while instance is running, but costs ~$3.6/month if instance is stopped. Consider releasing if not using for long periods.
- **Compilation:** t3.medium (4GB RAM) still needs 2GB swap + `-j1` to compile map-server (skill.cpp is huge). Swap setup: `sudo fallocate -l 2G /swapfile && sudo chmod 600 /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile`
