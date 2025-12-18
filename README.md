# FCLI Scripts
Wrapper scripts around [`fcli.jar`](https://github.com/fortify/fcli) for Linux and Windows. The scripts assume they are located under `<FCLI>/bin` and the .jar file is under `<FCLI>/lib`.

## Windows Installation
Save the scripts in a convenient location such as `C:\Program Files\Fortify\FCLI\bin`:
```bat
set FCLI_DIR=C:\Program Files\Fortify\FCLI
mkdir "%FCLI_DIR%\bin"
set PATH=%FCLI_DIR%\bin;%PATH%
curl "https://raw.githubusercontent.com/fortifysoftware/fcli-scripts/refs/heads/main/windows/fcli.bat" -o "%FCLI_DIR%\bin\fcli.bat"
curl "https://raw.githubusercontent.com/fortifysoftware/fcli-scripts/refs/heads/main/windows/fcli-update.bat" -o "%FCLI_DIR%\bin\fcli-update.bat"
```
If you then run `fcli -h` (or any other `fcli` command), the script will automatically download the latest version of `fcli.jar` if it's not detected under `C:\Program Files\Fortify\FCLI\lib`.

To update the .jar file, simply run `fcli-update`.

**Note:** both scripts assume `curl` is available on the system PATH.
