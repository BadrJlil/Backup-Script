@echo off
if not exist "D:\Data" (
    mkdir "D:\Data"
    echo Folder "Data" created in D:\
) else echo Folder "Data" exist already


echo This is a test file > "D:\Data\test.txt"
echo File "Test" created inside that folder

call "Setup\Add FTP to Firewall.bat"
echo FTP added to firewall

call "Backup Script.bat"
echo Backup tested

cd "Setup"
call "Backup Scheduler.bat"
echo Bakuckup scheduled

cd ../

mkdir c:\Backup-Server
move 7zip c:\Backup-Server
move Archives c:\Backup-Server
move "FTP Config.cfg" c:\Backup-Server
echo @echo off >> "c:\Backup-Server\Backup Script.bat"
echo cd c:\Backup-Server >> "c:\Backup-Server\Backup Script.bat"
type "Backup Script.bat" >> "c:\Backup-Server\Backup Script.bat"
echo Folder "Backup-Server" moved to c:\
pause

cd ../
rmdir /s /q Backup-Server
