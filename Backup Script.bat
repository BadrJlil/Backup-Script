echo Starting Backup, Don't close this window

goto :main

:check_connection
ping 192.168.1.20 -n 1 | FIND "TTL=" >NUL
if not ERRORLEVEL 1 goto :eof  else (
ping 192.168.1.20 -w 3000 | FIND "TTL=" >NUL
if ERRORLEVEL 1 goto :offline else goto :eof )

:connected
time /t >> "Archives\%archive%.log"
echo Connection established >> "Archives\%archive%.log"
echo. >> "Archives\%archive%.log"
goto :eof

:offline
time /t >> "Archives\%archive%.log"
echo Couldn't connect to the server >> "Archives\%archive%.log"
goto :end

:check_storage
time /t >> "Archives\%archive%.log"
FOR /F "tokens=3 USEBACKQ" %%F IN (`dir /-c /w C:`) DO set "FreeSpace=%%F"
cd "d:\"
set size=0
for /r %%x in (data\*) do set /a size+=%%~zx
if %FreeSpace% gtr %size% (
    echo Available space is enough >> "Archives\%archive%.log"
    echo. >> "Archives\%archive%.log"
    goto :eof
    ) else (
    echo Available space is not enough >> "Archives\%archive%.log"
    goto :end
)

:compress
time /t >> "Archives\%archive%.log"
7zip\7z.exe a "Archives\%archive%.zip" "d:\Data" >> "Archives\%archive%.log"
echo. >> "Archives\%archive%.log"
goto :eof

:upload
ftp -n -i 192.168.1.20 < "FTP Config.cfg" >> "Archives\%archive%.log"
goto :eof

:check_upload
findstr /C:"%Archive%" isituploaded.txt > NUL
if ERRORLEVEL 1 (
    time /t >> "Archives\%archive%.log"
    echo Couldn't find the file in the server >> "Archives\%archive%.log"
    del isituploaded.txt
    goto :end
    ) else (
        time /t >> "Archives\%archive%.log"
    echo Files uploaded successfully >> "Archives\%archive%.log"
    echo. >> "Archives\%archive%.log"
    del isituploaded.txt
    goto :eof
)

:archiving
rename "Archives\%archive%.zip" "%archive%.old"
time /t >> "Archives\%archive%.log"
echo Files archived >> "Archives\%archive%.log"
echo. >> "Archives\%archive%.log"
echo All Done >> "Archives\%archive%.log"
goto :eof

:main
for /f "tokens=1-3 delims=/" %%a in ("%date%") do set DD=%%a_%%b_%%c
for /f "tokens=1-3 delims=:," %%a in ("%Time%") do set TT=%%a_%%b
set archive=%username%_Backup_%DD%-%TT%
date /t > "Archives\%archive%.log"
echo. >> "Archives\%archive%.log"

echo Checking connection...
call :check_connection
call :connected
echo Cheking the storage...
call :check_storage
echo Compressing the folder...
call :compress
echo Checking connection again...
call :check_connection
echo Uploading the files...
call :upload
echo Checking uploaded files...
call :check_upload
echo Archiving old files...
call :archiving
echo Done
echo %DD% %TT%   upload complete >> "upload logs.log"
goto :eof

:end
echo. >> "Archives\%archive%.log"
if  exist "Archives\%archive%.zip"  (
    time /t >> "Archives\%archive%.log"
    del "Archives\%archive%.zip"
    echo Compressed files now deleted >> "Archives\%archive%.log"
    echo. >> "Archives\%archive%.log"
    )
echo Operation Abandoned >> "Archives\%archive%.log"
echo %DD% %TT%   upload failed >> "upload logs.log"
exit