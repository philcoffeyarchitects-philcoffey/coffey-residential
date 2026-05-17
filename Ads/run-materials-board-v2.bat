@echo off
cd /d "C:\Users\philc\Documents\Claude\Claude Code\coffey-residential\Ads"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\download-materials-board-v2.ps1" > materials-board-v2-debug.log 2>&1
echo Exit code: %ERRORLEVEL% >> materials-board-v2-debug.log
