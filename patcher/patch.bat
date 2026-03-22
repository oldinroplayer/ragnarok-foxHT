@echo off
:: FoxHT Patch v2 - Fixes de skills e quests
:: Este arquivo e baixado e executado pelo launcher automaticamente

echo  [1/2] Corrigindo crash na janela de Skills (ALT+S)...
del /q "data\skilltreeview.txt" 2>nul
del /q "data\skilldesctable.txt" 2>nul
del /q "data\skillnametable.txt" 2>nul
del /q "data\luafiles514\lua files\skillinfoz\skilldescript.lub" 2>nul
del /q "data\luafiles514\lua files\skillinfoz\skillinfolist.lub" 2>nul
del /q "data\luafiles514\lua files\skillinfoz\skilltreeview.lub" 2>nul
del /q "data\luafiles514\lua files\skillinfoz\skillid.lub" 2>nul
del /q "data\lua files\skillinfoz\skilldescript.lub" 2>nul
del /q "data\lua files\skillinfoz\skillinfolist.lub" 2>nul
del /q "data\lua files\skillinfoz\skilltreeview.lub" 2>nul

echo  [2/2] Corrigindo erro de Quest em alguns mapas...
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

echo  Patches aplicados!
