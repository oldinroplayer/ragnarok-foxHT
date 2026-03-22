# FoxHT — Ragnarok Online Private Server

Servidor privado de Ragnarok Online baseado no [rAthena](https://github.com/rathena/rathena), configurado para jogo casual entre amigos (PVP & MVPs).

## Configurações do Servidor

| Setting | Value |
|---------|-------|
| Modo | Pre-Renewal (clássico) |
| Rates | 100x/100x/20x (base/job/drop) |
| Level Máximo | 99/70 |
| Episódio | 13.2 (Satan Morroc) |
| Packet Version | 20200218 |

## Estrutura do Repositório

```
ragnarok/
├── server/                    # Customizações do servidor
│   ├── conf/import/           # Configs que sobrescrevem o rAthena padrão
│   │   ├── battle_conf.txt    # Rates, drop, penalidade de morte
│   │   ├── char_conf.txt      # Nome do server, IP, pincode
│   │   ├── map_conf.txt       # IP do map-server
│   │   ├── login_conf.txt     # Criação de conta via _M/_F
│   │   ├── inter_conf.txt     # Credenciais MySQL
│   │   └── groups.yml         # Comandos @ liberados para jogadores
│   ├── npc/                   # NPCs customizados
│   │   ├── scripts_custom.conf
│   │   └── custom/
│   │       ├── pvp_warper.txt       # NPC Warper para salas PVP
│   │       ├── instance_warper.txt  # NPC Guia de Instâncias
│   │       ├── command_guide.txt    # NPC que lista todos os @comandos
│   │       └── login_message.txt    # Mensagem de boas-vindas ao logar
│   └── scripts/               # Scripts de operação
│       ├── deploy.sh           # Copia customizações para o rAthena
│       ├── start.sh            # Inicia os 3 servidores
│       ├── stop.sh             # Para os servidores
│       └── restart.sh          # Reinicia tudo
├── client/                    # Arquivos do client (configs apenas)
│   ├── clientinfo.xml         # Config de conexão (IP, porta)
│   └── data/
│       ├── clientinfo.xml     # Cópia para o patch "Read Data Folder First"
│       └── msgstringtable.txt # Tradução EN dos textos do client
└── docs/                      # Documentação adicional
```

## Setup Rápido — Servidor

### Pré-requisitos
- Ubuntu 22.04 (recomendado: AWS EC2 t3.medium)
- MySQL 8.0+
- 4GB RAM + 2GB swap

### Instalação

```bash
# 1. Clonar rAthena
git clone https://github.com/rathena/rathena.git ~/rathena
cd ~/rathena

# 2. Clonar este repositório
git clone https://github.com/lucasarlop/ragnarok.git ~/foxht

# 3. Aplicar customizações
chmod +x ~/foxht/server/scripts/*.sh
~/foxht/server/scripts/deploy.sh ~/rathena

# 4. Configurar MySQL
mysql -u root -p -e "CREATE DATABASE ragnarok; CREATE USER 'ragnarok'@'localhost' IDENTIFIED BY 'ragnarok'; GRANT ALL ON ragnarok.* TO 'ragnarok'@'localhost';"
mysql -u ragnarok -p ragnarok < sql-files/main.sql
mysql -u ragnarok -p ragnarok < sql-files/logs.sql

# 5. Configurar swap (necessário para compilação)
sudo fallocate -l 2G /swapfile && sudo chmod 600 /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile

# 6. Compilar (IMPORTANTE: usar -j1 para não estourar memória)
./configure --enable-prere=yes --enable-packetver=20200218
make clean && make server -j1

# 7. Iniciar
~/foxht/server/scripts/start.sh ~/rathena
```

### Atualizando após mudanças no repo

```bash
cd ~/foxht
git pull
./server/scripts/deploy.sh ~/rathena
./server/scripts/restart.sh ~/rathena
```

## Setup Rápido — Client

1. Baixar o client completo via Google Drive (link no grupo)
2. Ou montar manualmente:
   - Baixar kRO 2020-03-04 files do [NEMO](http://nemo.herc.ws/clients/)
   - Baixar Ragexe 20200218 e patchar com NEMO (patches: SELECT RECOMMENDED + Read Data Folder First)
   - Copiar `client/clientinfo.xml` para a raiz e `client/data/*` para `data/`

## Comandos Disponíveis (@)

Todos os jogadores têm acesso a comandos úteis. Digite `@commands` no jogo ou fale com o NPC **Command Guide** em Prontera.

**Destaques:**
- `@go [cidade]` — Teleportar para cidades
- `@warp [mapa] [x] [y]` — Teleportar para qualquer mapa
- `@item [id] [qtd]` — Criar itens
- `@baselvl [nível]` — Definir nível base (máx 99)
- `@joblvl [nível]` — Definir nível de job (máx 70)
- `@jobchange [id]` — Mudar de classe
- `@heal` — Curar HP/SP completo
- `@autoloot` — Coletar drops automaticamente
- `@storage` — Abrir armazém

## Contribuindo

1. Clone o repositório
2. Faça suas alterações nos arquivos dentro de `server/` ou `client/`
3. Teste localmente ou no servidor
4. Commit e push — o outro colaborador faz `git pull` + `deploy.sh`

**Regra importante:** Nunca edite os arquivos base do rAthena. Todas as customizações vão em `conf/import/` (configs) ou `npc/custom/` (NPCs).
