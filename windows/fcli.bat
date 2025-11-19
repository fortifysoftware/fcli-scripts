@echo off
setlocal EnableDelayedExpansion

set FCLI_HOME=%~dp0
set "FCLI_HOME=%FCLI_HOME:~0,-1%"
for %%I in ("%FCLI_HOME%") do set "FCLI_HOME=%%~dpI"
set "FCLI_HOME=%FCLI_HOME:~0,-1%"
set FCLI_PATH=%FCLI_HOME%\lib
set FCLI_JAR=fcli.jar

rem Locate java binary
set JAVA_CMD=
for /f "delims=" %%A in ('dir /A:D /S /B /O:N "C:\Program Files\Java\jdk-17*"') do (set JAVA_CMD=%%A\bin\java.exe)
if not exist "%JAVA_CMD%" (
    if exist "%JAVA_HOME%\" (set JAVA_CMD=%JAVA_HOME%\bin\java.exe)
    if not exist "!JAVA_CMD!" (
        set JAVA_CMD=java.exe
        where /q !JAVA_CMD!
        if errorlevel 1 (
            echo Java not detected. Exiting...
            exit /b 1
        )
    )
)

if not exist "%FCLI_PATH%\%FCLI_JAR%" (
    echo %FCLI_JAR% does not exist. Attempting to download...
    curl -s -L "https://github.com/fortify/fcli/releases/download/latest/fcli.jar" -o "%FCLI_PATH%\%FCLI_JAR%"
    if errorlevel 1 (
        echo Failed to download latest %FCLI_JAR%. Likely reasons:
        echo - curl command is unavailable
        echo - Administrative privileges may be required to save the file
        echo - Permission issues
        echo Exiting...
        exit /b 1
    )
)

"%JAVA_CMD%" -Xmx8G -jar "%FCLI_PATH%\%FCLI_JAR%" %*
