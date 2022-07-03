@echo off
schtasks /create /xml "Backup Scheduler.xml" /tn "Backup Data Folder"
echo Task scheduled
pause