@echo off
:: FoxHT Patch v4 - Fixes + Traducao EN (itens e skills)
:: Este arquivo e baixado e executado pelo launcher automaticamente

set "REPO=https://raw.githubusercontent.com/lucasarlop/ragnarok/main"

echo  [1/5] Corrigindo crash na janela de Skills (ALT+S)...
del /q "data\skilltreeview.txt" 2>nul
del /q "data\luafiles514\lua files\skillinfoz\skilldescript.lub" 2>nul
del /q "data\luafiles514\lua files\skillinfoz\skillinfolist.lub" 2>nul
del /q "data\luafiles514\lua files\skillinfoz\skilltreeview.lub" 2>nul
del /q "data\luafiles514\lua files\skillinfoz\skillid.lub" 2>nul
del /q "data\lua files\skillinfoz\skilldescript.lub" 2>nul
del /q "data\lua files\skillinfoz\skillinfolist.lub" 2>nul
del /q "data\lua files\skillinfoz\skilltreeview.lub" 2>nul

echo  [2/5] Corrigindo erro de Quest em alguns mapas...
if not exist "data\luafiles514\lua files\datainfo" mkdir "data\luafiles514\lua files\datainfo"
(
echo -- FoxHT: Fixed QuestInfo_f.lua for Pre-Renewal
echo function GetOngoingQuestInfoByID^(questID^)
echo     local questInfo = QuestTable[questID]
echo     if questInfo == nil then return "" end
echo     return questInfo
echo end
echo function GetQuestInfoByID^(questID^)
echo     local questInfo = QuestTable[questID]
echo     if questInfo == nil then return "" end
echo     return questInfo
echo end
) > "data\luafiles514\lua files\datainfo\QuestInfo_f.lua"

echo  [3/5] Baixando traducao de skills (EN)...
curl -s -f "%REPO%/client/data/skillnametable.txt" -o "data\skillnametable.txt" 2>nul
curl -s -f "%REPO%/client/data/skilldesctable.txt" -o "data\skilldesctable.txt" 2>nul

echo  [4/5] Baixando traducao de itens (EN)...
echo         (arquivo grande, pode demorar um pouco)
curl -s -f -L "%REPO%/client/System/itemInfo_true.lub" -o "System\itemInfo_true.lub" 2>nul
if exist "System\itemInfo_true.lub" (
    copy /y "System\itemInfo_true.lub" "System\itemInfo_Sak.lub" >nul 2>nul
    copy /y "System\itemInfo_true.lub" "System\itemInfo_indoor.lub" >nul 2>nul
    echo         Itens traduzidos com sucesso!
) else (
    echo         [AVISO] Falha ao baixar traducao de itens.
    echo         Verifique sua conexao com a internet.
)

echo  [5/5] Limpando arquivos antigos desnecessarios...
del /q "data\luafiles514\lua files\datainfo\iteminfo.lua" 2>nul

echo  Patches aplicados!
