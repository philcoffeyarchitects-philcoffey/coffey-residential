@echo off
cd /d "C:\Users\philc\Documents\Claude\Claude Code\coffey-residential\Ads"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\download-all-materials-boards.ps1" > all-boards-debug.log 2>&1
echo Exit code: %ERRORLEVEL% >> all-boards-debug.log
