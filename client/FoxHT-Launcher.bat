@echo off
title FoxHT Launcher
color 0E
echo.
echo  ============================================
echo       FoxHT - Ragnarok Online Launcher
echo  ============================================
echo.

:: GitHub raw URL base
set "REPO=https://raw.githubusercontent.com/lucasarlop/ragnarok/main"

:: Check if curl exists
where curl >nul 2>&1
if errorlevel 1 (
    echo [ERRO] curl nao encontrado. Abrindo o jogo sem atualizar...
    goto :launch
)

:: Download version file from GitHub
echo  Verificando atualizacoes...
curl -s -f "%REPO%/patcher/version.txt" -o "_remote_version.txt" 2>nul
if errorlevel 1 (
    echo  Sem conexao ou servidor indisponivel. Abrindo o jogo...
    del /q "_remote_version.txt" 2>nul
    goto :launch
)

:: Compare versions
set LOCAL_VER=0
if exist "_local_version.txt" set /p LOCAL_VER=<"_local_version.txt"
set /p REMOTE_VER=<"_remote_version.txt"
del /q "_remote_version.txt" 2>nul

if "%LOCAL_VER%"=="%REMOTE_VER%" (
    echo  Jogo ja esta atualizado! (v%LOCAL_VER%)
    echo.
    goto :launch
)

echo  Atualizacao encontrada! v%LOCAL_VER% -^> v%REMOTE_VER%
echo  Baixando atualizacoes...
echo.

:: Download patch script and run it
curl -s -f "%REPO%/patcher/patch.bat" -o "_patch.bat" 2>nul
if errorlevel 1 (
    echo  [ERRO] Falha ao baixar patch. Abrindo o jogo sem atualizar...
    goto :launch
)

call "_patch.bat"
del /q "_patch.bat" 2>nul

:: Update local version
(echo %REMOTE_VER%)> "_local_version.txt"
echo.
echo  Atualizado com sucesso para v%REMOTE_VER%!
echo.

:launch
echo  Iniciando FoxHT...
echo.
start "" "FoxHT.exe"
exit
