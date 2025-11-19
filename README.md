# FCLI Scripts
Wrapper scripts around [`fcli.jar`](https://github.com/fortify/fcli) for Linux and Windows.

## Windows Installation
Save the scripts in a convenient location such as `C:\Program Files\Fortify\FCLI\bin`:
```bat
mkdir "C:\Program Files\Fortify\FCLI\bin"
set PATH=C:\Program Files\Fortify\FCLI\bin;%PATH%
curl "https://raw.githubusercontent.com/fortifysoftware/fcli-scripts/refs/heads/main/windows/fcli.bat" -o "C:\Program Files\Fortify\FCLI\bin\fcli.bat"
curl "https://raw.githubusercontent.com/fortifysoftware/fcli-scripts/refs/heads/main/windows/fcli-update.bat" -o "C:\Program Files\Fortify\FCLI\bin\fcli-update.bat"
```
If you then run `fcli -h` (or any other `fcli` command), the script will automatically download the latest version of `fcli.jar` if it's not detected under `C:\Program Files\Fortify\FCLI\lib`.

To update the .jar file, simply run `fcli-update`.

**Note:** both scripts assume `curl` is available on the system PATH.
