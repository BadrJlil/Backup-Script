@echo off
if not exist "D:\Data" (
    mkdir "D:\Data"
    echo Folder "Data" created in D:\
) else echo Folder "Data" exist already
pause