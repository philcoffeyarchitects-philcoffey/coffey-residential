@echo off
cd /d "C:\Users\philc\Documents\Claude\Claude Code\coffey-residential\Ads"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\download-materials-board.ps1" > materials-board-debug.log 2>&1
echo Exit code: %ERRORLEVEL% >> materials-board-debug.log
