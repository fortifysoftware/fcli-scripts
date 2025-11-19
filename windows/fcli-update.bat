@echo off
setlocal ENABLEDELAYEDEXPANSION

REM ====== CONFIG ======
set "repo=fortify/fcli"
set "exe=fcli"

REM ====== GET INSTALLED VERSION (strip trailing comma) ======
for /f "tokens=3 delims= " %%A in ('%exe% -V ^| findstr /i "version"') do (
    set "installed=%%A"
)
REM remove any comma that might be attached
set "installed=%installed:,=%"
echo Installed version: %installed%

REM ====== GET LATEST GITHUB RELEASE VERSION (strip quotes/comma/whitespace) ======
for /f "usebackq tokens=2 delims=:" %%A in (`
    curl -s "https://api.github.com/repos/%repo%/releases/latest" ^| findstr /i "\"tag_name\""
`) do (
    set "latest=%%A"
)

REM remove spaces, quotes and trailing commas from the extracted value
set "latest=!latest: =!"
set "latest=!latest:"=!"
set "latest=!latest:,=!"
set "latest=!latest:v=!"
echo Latest release:    %latest%

REM ====== NORMALIZE (remove leading v if present) ======
set "installedNorm=%installed%"
set "latestNorm=%latest:v=%"

REM ====== COMPARE VERSIONS ======
call :compareVersions "%installedNorm%" "%latestNorm%" result

if %result%==0 (
    echo Versions are equal. Update not necessary.
) else if %result%==1 (
    echo Installed version is newer than GitHub release. Shouldn't be possible^^!
) else if %result%==2 (
    echo Update available^^! Latest version is %latest%.
    call :download
)

exit /b

REM =====================================================
REM Version comparison function
REM Returns:
REM   0 = equal
REM   1 = installed > latest
REM   2 = installed < latest
REM =====================================================
:compareVersions
setlocal
set "v1=%~1"
set "v2=%~2"

call :splitVersion "%v1%" v1a v1b v1c
call :splitVersion "%v2%" v2a v2b v2c

if %v1a% GTR %v2a% (endlocal & set "%3=1" & exit /b)
if %v1a% LSS %v2a% (endlocal & set "%3=2" & exit /b)

if %v1b% GTR %v2b% (endlocal & set "%3=1" & exit /b)
if %v1b% LSS %v2b% (endlocal & set "%3=2" & exit /b)

if %v1c% GTR %v2c% (endlocal & set "%3=1" & exit /b)
if %v1c% LSS %v2c% (endlocal & set "%3=2" & exit /b)

endlocal & set "%3=0"
exit /b

REM Split X.Y.Z into numeric variables
:splitVersion
setlocal
set "v=%~1"

for /f "tokens=1-3 delims=." %%a in ("%v%") do (
    endlocal & set "%2=%%a" & set "%3=%%b" & set "%4=%%c" & exit /b
)

:download
set FCLI_HOME=%~dp0
set "FCLI_HOME=%FCLI_HOME:~0,-1%"
for %%I in ("%FCLI_HOME%") do set "FCLI_HOME=%%~dpI"
set "FCLI_HOME=%FCLI_HOME:~0,-1%"
set FCLI_PATH=%FCLI_HOME%\lib
set FCLI_JAR=fcli.jar

echo Attempting to download latest %FCLI_JAR%...
curl -s -L "https://github.com/fortify/fcli/releases/download/latest/fcli.jar" -o "%FCLI_PATH%\%FCLI_JAR%"
if errorlevel 1 (
    echo Failed to download latest %FCLI_JAR%. Likely reasons:
    echo - curl command is unavailable
    echo - Administrative privileges may be required to save the file
    echo - Permission issues
    echo Exiting...
    exit /b 1
)
echo Update successful^^!
