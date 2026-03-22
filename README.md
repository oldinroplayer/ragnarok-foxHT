# FoxHT — Ragnarok Online Private Server

Servidor privado de Ragnarok Online baseado no [rAthena](https://github.com/rathena/rathena), configurado para jogo casual entre amigos (PVP & MVPs).

## Configuracoes do Servidor

| Setting | Value |
|---------|-------|
| Modo | Pre-Renewal (classico) |
| Rates | 100x/100x/20x (base/job/drop) |
| Level Maximo | 99/70 |
| Episodio | 13.2 (Satan Morroc) |
| Packet Version | 20200218 |
| Client | kRO 2020-03-04 (Ragexe 20200218) |

## Estrutura do Repositorio

```
ragnarok/
├── server/                        # Customizacoes do servidor
│   ├── conf/import/               # Configs que sobrescrevem o rAthena padrao
│   │   ├── battle_conf.txt        # Rates, drop, penalidade de morte
│   │   ├── char_conf.txt          # Nome do server, IP, pincode
│   │   ├── map_conf.txt           # IP do map-server
│   │   ├── login_conf.txt         # Criacao de conta via _M/_F
│   │   ├── inter_conf.txt         # Credenciais MySQL
│   │   └── groups.yml             # Comandos @ liberados para jogadores
│   ├── npc/                       # NPCs customizados
│   │   ├── scripts_custom.conf
│   │   └── custom/
│   │       ├── pvp_warper.txt           # NPC Warper para salas PVP
│   │       ├── instance_warper.txt      # NPC Guia de Instancias
│   │       ├── command_guide.txt        # NPC que lista todos os @comandos
│   │       └── login_message.txt        # Mensagem de boas-vindas ao logar
│   └── scripts/                   # Scripts de operacao
│       ├── deploy.sh              # Copia customizacoes para o rAthena
│       ├── start.sh               # Inicia os 3 servidores
│       ├── stop.sh                # Para os servidores
│       └── restart.sh             # Reinicia tudo
├── client/                        # Arquivos do client
│   ├── FoxHT-Launcher.bat         # Launcher com auto-update
│   ├── clientinfo.xml             # Config de conexao (IP, porta)
│   └── data/
│       ├── clientinfo.xml         # Copia para o patch "Read Data Folder First"
│       ├── msgstringtable.txt     # Traducao EN dos textos do client
│       └── luafiles514/.../QuestInfo_f.lua  # Fix de erro de quest
└── patcher/                       # Sistema de auto-update
    ├── version.txt                # Versao atual do patch (incrementar a cada update)
    └── patch.bat                  # Script de patch (baixado pelo launcher)
```

## Setup Rapido — Servidor

### Pre-requisitos
- Ubuntu 22.04 (recomendado: AWS EC2 t3.medium)
- MySQL 8.0+
- 4GB RAM + 2GB swap

### Instalacao

```bash
# 1. Clonar rAthena
git clone https://github.com/rathena/rathena.git ~/rathena
cd ~/rathena

# 2. Clonar este repositorio
git clone https://github.com/lucasarlop/ragnarok.git ~/foxht

# 3. Aplicar customizacoes
chmod +x ~/foxht/server/scripts/*.sh
~/foxht/server/scripts/deploy.sh ~/rathena

# 4. Configurar MySQL
mysql -u root -p -e "CREATE DATABASE ragnarok; CREATE USER 'ragnarok'@'localhost' IDENTIFIED BY 'ragnarok'; GRANT ALL ON ragnarok.* TO 'ragnarok'@'localhost';"
mysql -u ragnarok -p ragnarok < sql-files/main.sql
mysql -u ragnarok -p ragnarok < sql-files/logs.sql

# 5. Configurar swap (necessario para compilacao)
sudo fallocate -l 2G /swapfile && sudo chmod 600 /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile

# 6. Compilar (IMPORTANTE: usar -j1 para nao estourar memoria)
./configure --enable-prere=yes --enable-packetver=20200218
make clean && make server -j1

# 7. Iniciar
~/foxht/server/scripts/start.sh ~/rathena
```

### Atualizando o servidor apos mudancas no repo

```bash
cd ~/foxht
git pull
./server/scripts/deploy.sh ~/rathena
./server/scripts/restart.sh ~/rathena
```

## Setup Rapido — Client

1. Baixar o client completo via Google Drive (link no grupo)
2. Ou montar manualmente:
   - Baixar kRO 2020-03-04 files do [NEMO](http://nemo.herc.ws/clients/)
   - Baixar Ragexe 20200218 e patchar com NEMO (patches: SELECT RECOMMENDED + Read Data Folder First)
   - Copiar `client/clientinfo.xml` para a raiz e `client/data/*` para `data/`

## Launcher (Auto-Update)

Os jogadores devem usar o **FoxHT-Launcher.bat** em vez de abrir o FoxHT.exe diretamente. O launcher:

1. Verifica se ha atualizacao no GitHub (`patcher/version.txt`)
2. Se a versao remota for maior que a local, baixa e executa o `patcher/patch.bat`
3. Salva a versao local em `_local_version.txt`
4. Abre o jogo

### Como enviar um update para os jogadores

1. Edite `patcher/patch.bat` com os comandos do novo patch (deletar arquivos, baixar novos, etc.)
2. Incremente o numero em `patcher/version.txt` (ex: `1` → `2`)
3. Faca `git commit` e `git push`
4. Na proxima vez que qualquer jogador abrir o launcher, recebe a atualizacao automaticamente

**Exemplo de patch.bat:**
```bat
@echo off
set "REPO=https://raw.githubusercontent.com/lucasarlop/ragnarok/main"

echo  Aplicando correcoes...
:: Deletar arquivos problematicos
del /q "data\arquivo_errado.txt" 2>nul
:: Baixar arquivos novos do repo
curl -s -f "%REPO%/client/data/novo_arquivo.txt" -o "data\novo_arquivo.txt" 2>nul

echo  Patches aplicados!
```

### Importante sobre arquivos do client

- **NAO** coloque arquivos de skill soltos em `data/` — o GRF original ja tem as versoes corretas
- Arquivos soltos em `data/` sobrescrevem o GRF (por causa do patch "Read Data Folder First")
- So use `data/` para arquivos que realmente precisam ser customizados (clientinfo.xml, msgstringtable.txt, QuestInfo_f.lua)

## Comandos Disponiveis (@)

Todos os jogadores tem acesso a comandos uteis. Digite `@commands` no jogo ou fale com o NPC **Command Guide** em Prontera.

**Destaques:**
- `@go [cidade]` — Teleportar para cidades
- `@warp [mapa] [x] [y]` — Teleportar para qualquer mapa
- `@item [id] [qtd]` — Criar itens
- `@baselvl [nivel]` — Definir nivel base (max 99)
- `@joblvl [nivel]` — Definir nivel de job (max 70)
- `@jobchange [id]` — Mudar de classe
- `@heal` — Curar HP/SP completo
- `@autoloot` — Coletar drops automaticamente
- `@storage` — Abrir armazem

## Contribuindo

1. Clone o repositorio
2. Faca suas alteracoes nos arquivos dentro de `server/` ou `client/`
3. Teste localmente ou no servidor
4. Commit e push

### Fluxo de trabalho

**Mudancas no servidor** (configs, NPCs):
```
Editar arquivos em server/ → git push → SSH no servidor → git pull + deploy.sh + restart.sh
```

**Mudancas no client** (fixes, traducoes):
```
Editar arquivos em client/ → atualizar patcher/patch.bat → incrementar patcher/version.txt → git push
Os jogadores recebem automaticamente pelo launcher.
```

**Regra importante:** Nunca edite os arquivos base do rAthena. Todas as customizacoes vao em `conf/import/` (configs) ou `npc/custom/` (NPCs).
