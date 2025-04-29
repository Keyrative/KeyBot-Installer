# Set the title of the PowerShell window
$Host.UI.RawUI.WindowTitle = "KeyBot Installer v1.0"
# Define a function to convert bytes to megabytes
function Convert-BytesToMB {
    param (
        [int]$bytes
    )
    return [math]::Round($bytes / 1MB, 2)
}
# Set background color, get console size, and clear the console with background color
[System.Console]::BackgroundColor = [System.ConsoleColor]::Black
[System.Console]::ForegroundColor = [System.ConsoleColor]::Green
$width = [System.Console]::WindowWidth
$height = [System.Console]::WindowHeight
for ($i = 0; $i -lt $height; $i++) {
    Write-Host (" " * $width) # Write a line of spaces to cover the entire width
}

# Define variables
$installerPath = "$env:USERPROFILE\Downloads\python-3.12.1-amd64.exe"
$pythonUrl = "https://www.python.org/ftp/python/3.12.1/python-3.12.1-amd64.exe"
$acctAuthUrl = "https://raw.githubusercontent.com/Keyrative/KeyBot-Installer/refs/heads/main/KeyFiles/AcctAuth3.0.ps1"
$requirementsUrl = "https://raw.githubusercontent.com/Keyrative/TwitchMarkovChain/refs/heads/master/requirements.txt"
$keyUninstallerUrl = "https://github.com/Keyrative/KeyBot-Installer/raw/refs/heads/main/KeyFiles/KeyBotUninstaller.ps1"
$pipPath = "C:\Users\$env:USERNAME\AppData\Local\Programs\Python\Python312\Scripts\pip.exe"
$tempFile = [System.IO.Path]::GetTempFileName()


# Display an image
# $scriptContent = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/DevAndersen/posh-bucket/master/projects/consoleImageRenderer/consoleImageRenderer.ps1" -UseBasicParsing | Select-Object -ExpandProperty Content
# $scriptBlock = [ScriptBlock]::Create($scriptContent)
# & $scriptBlock -Path "D:\Users\Foster\Pictures\scary pearl 120.png" -Width 50 -Height 50

# Function to download a file with progress reporting
function Download-FileWithProgress {
    param (
        [string]$url,
        [string]$outputPath
    )

    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($url, $outputPath)

    # Get the file size
    $fileInfo = Get-Item -Path $outputPath
    $bytesWritten = $fileInfo.Length
    $mbWritten = Convert-BytesToMB -bytes $bytesWritten

    Write-Host "Download complete: python-3.12.1-amd64.exe $mbWritten MB"
}

# Check if the Python installer already exists, download if it doesn't
if (-Not (Test-Path -Path $installerPath)) {
    [System.Console]::ForegroundColor = [System.ConsoleColor]::Green
    Write-Host "Downloading Python 3.12.1..."
    Download-FileWithProgress -url $pythonUrl -outputPath $installerPath
} else {
    [System.Console]::ForegroundColor = [System.ConsoleColor]::DarkRed
    Write-Host "Python installer already exists at $installerPath"
}

# Uninstalls previous key bot versions
Invoke-Expression (Invoke-WebRequest -Uri $keyUninstallerUrl | Select-Object -ExpandProperty Content)


[System.Console]::ForegroundColor = [System.ConsoleColor]::DarkGray
Write-Host ("`n-----------------------------STEP 1------------------------------`n")
[System.Console]::ForegroundColor = [System.ConsoleColor]::White

Write-Host "KeyBot is a Python script. If you don't follow the next three steps
and install Python, KeyBot will not work.

If you are updating or re-installing, you can skip the Python installation by 
clicking cancel.

1. After starting the Python installer, click 'Use admin priveleges when
installing py.exe'
2. Click 'Add python.exe to PATH'
3. Click 'Install Now' and finish installing"

[System.Console]::ForegroundColor = [System.ConsoleColor]::Yellow
Write-Host "`nPress any key to start installing python..."
[System.Console]::ForegroundColor = [System.ConsoleColor]::White
[void][System.Console]::ReadKey($true)

# Run python installer
Start-Process -FilePath $installerPath
Wait-Process -Name python-3.12.1-amd64

[System.Console]::ForegroundColor = [System.ConsoleColor]::DarkGray
Write-Host ("`n-----------------------------STEP 2------------------------------`n")
[System.Console]::ForegroundColor = [System.ConsoleColor]::White
Write-Host "Installing python dependencies...`n"

# Download the requirements.txt file
Invoke-WebRequest -Uri $requirementsUrl -OutFile $tempFile

# Install the Python packages
& $pipPath install -r $tempFile
& "C:\Users\$env:USERNAME\AppData\Local\Programs\Python\Python312\Scripts\pip.exe" install nltk

[System.Console]::ForegroundColor = [System.ConsoleColor]::Yellow
Write-Host "`nPress any key to continue..."
[void][System.Console]::ReadKey($true)
[System.Console]::ForegroundColor = [System.ConsoleColor]::DarkGray
Write-Host ("`n-----------------------------STEP 3------------------------------`n")
[System.Console]::ForegroundColor = [System.ConsoleColor]::White

# AcctAuth
Invoke-Expression (Invoke-WebRequest -Uri $acctAuthUrl | Select-Object -ExpandProperty Content)

# Create KeyBot folder
$keySettingsFolder = Join-Path -Path $env:USERPROFILE -ChildPath "Documents\Applications\KeyBot\TwitchMarkovChain"
New-Item -Path $keySettingsFolder -ItemType Directory -Force | Out-Null

# Copy temporary KeyBot info to documents folder
$keySettingsTempFolder = Join-Path -Path $env:USERPROFILE -ChildPath "Downloads\KeyFiles\TwitchMarkovChain"
Copy-Item -Path $keySettingsTempFolder\* -Destination "$keySettingsFolder" -Recurse -Force

#Copy KeyBot launcher and icons to documents
Copy-Item -Path "$env:USERPROFILE\Downloads\KeyFiles\KeyBot.ps1" -Destination "$env:USERPROFILE\Documents\Applications\KeyBot" -Recurse -Force
Copy-Item -Path "$env:USERPROFILE\Downloads\KeyFiles\key icon.ico" -Destination "$env:USERPROFILE\Documents\Applications\KeyBot" -Recurse -Force
Copy-Item -Path "$env:USERPROFILE\Downloads\KeyFiles\KeyBotUninstaller.ps1" -Destination "$env:USERPROFILE\Documents\Applications\KeyBot" -Recurse -Force
Copy-Item -Path "$env:USERPROFILE\Downloads\KeyFiles\KeyEditor.ps1" -Destination "$env:USERPROFILE\Documents\Applications\KeyBot" -Recurse -Force
Copy-Item -Path "$env:USERPROFILE\Downloads\KeyFiles\KeyBotUpdater.ps1" -Destination "$env:USERPROFILE\Documents\Applications\KeyBot" -Recurse -Force

# Create Desktop shortcut for Twitch KeyBot.ps1
$scriptPath = "$env:USERPROFILE\Documents\Applications\KeyBot\KeyBot.ps1"
$desktopPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath("Desktop"))
$shortcutPath = [System.IO.Path]::Combine($desktopPath, "KeyBot.lnk")
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($shortcutPath)
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Arguments = "-File `"$scriptPath`""
$Shortcut.WorkingDirectory = [System.IO.Path]::GetDirectoryName($scriptPath)
$Shortcut.IconLocation = "$env:USERPROFILE\Documents\Applications\KeyBot\key icon.ico"
$Shortcut.Save()

# Create Desktop shortcut for KeyEditor.ps1
$editorScriptPath = "$env:USERPROFILE\Documents\Applications\KeyBot\KeyEditor.ps1"
$editorShortcutPath = [System.IO.Path]::Combine($desktopPath, "KeyEditor.lnk")
$editorShortcut = $WshShell.CreateShortcut($editorShortcutPath)
$editorShortcut.TargetPath = "powershell.exe"
$editorShortcut.Arguments = "-File `"$editorScriptPath`""
$editorShortcut.WorkingDirectory = [System.IO.Path]::GetDirectoryName($editorScriptPath)
$editorShortcut.IconLocation = "$env:USERPROFILE\Documents\Applications\KeyBot\key icon.ico"
$editorShortcut.Save()

# Create Desktop shortcut for KeyUpdater.ps1
$UpdaterScriptPath = "$env:USERPROFILE\Documents\Applications\KeyBot\KeyBotUpdater.ps1"
$UpdaterShortcutPath = [System.IO.Path]::Combine($desktopPath, "KeyUpdater.lnk")
$UpdaterShortcut = $WshShell.CreateShortcut($UpdaterShortcutPath)
$UpdaterShortcut.TargetPath = "powershell.exe"
$UpdaterShortcut.Arguments = "-File `"$UpdaterScriptPath`""
$UpdaterShortcut.WorkingDirectory = [System.IO.Path]::GetDirectoryName($UpdaterScriptPath)
$UpdaterShortcut.IconLocation = "$env:USERPROFILE\Documents\Applications\KeyBot\key icon.ico"
$UpdaterShortcut.Save()

# Change some default settings
$settingsFilePath = "$env:USERPROFILE\Documents\Applications\KeyBot\TwitchMarkovChain\Settings.py"
$settingsContent = Get-Content $settingsFilePath
$settingsContent = $settingsContent -replace '"MaxSentenceWordAmount":\s*\d+,', '"MaxSentenceWordAmount": 40,'
$settingsContent = $settingsContent -replace '"HelpMessageTimer":\s*60\s*\*\s*60\s*\*\s*5,.*', '"HelpMessageTimer": 60 * 60 * 60,'
$settingsContent = $settingsContent -replace '"WhisperCooldown":\s*True,', '"WhisperCooldown": False,'
$settingsContent | Set-Content $settingsFilePath

# Have the user make the shortcut run as admin
[System.Console]::ForegroundColor = [System.ConsoleColor]::DarkGray
Write-Host ("`n-----------------------------STEP 4------------------------------`n")
[System.Console]::ForegroundColor = [System.ConsoleColor]::White
Write-Host "If you don't do these next steps,KeyBot may not start correctly.
1. Right click the new 'KeyBot' shortcut on your desktop
2. Click Properties
3. Select 'Shortcut' from the menu on top
4. Click 'Advanced'
5. Click 'Run as administrator'
6. Click 'OK'"
[System.Console]::ForegroundColor = [System.ConsoleColor]::Yellow
Write-Host "`nPress any key to continue..."
[void][System.Console]::ReadKey($true)
[System.Console]::ForegroundColor = [System.ConsoleColor]::White

#copy shortcuts to start menu
Copy-Item -Path "$env:USERPROFILE\Desktop\KeyBot.lnk" -Destination "$env:USERPROFILE\Documents\Pinned Folders\Start Menu Programs" -Recurse -Force
Copy-Item -Path "$env:USERPROFILE\Desktop\KeyEditor.lnk" -Destination "$env:USERPROFILE\Documents\Pinned Folders\Start Menu Programs" -Recurse -Force

[System.Console]::ForegroundColor = [System.ConsoleColor]::DarkGray
Write-Host ("`n-----------------------------STEP 5------------------------------`n")
[System.Console]::ForegroundColor = [System.ConsoleColor]::White
Write-Host "We need to run KeyBot to set some things up. Press any key in this 
window to run KeyBot, then press any key to continue in the new command prompt
window that pops up if prompted.

Close the new windows that open when it's done (DON'T ClOSE THIS WINDOW)."

[System.Console]::ForegroundColor = [System.ConsoleColor]::Yellow
Write-Host "`nPress any key to continue..."
[void][System.Console]::ReadKey($true)

#Run Keybot from desktop
Start-Process -FilePath "$env:USERPROFILE\Desktop\KeyBot.lnk"

[System.Console]::ForegroundColor = [System.ConsoleColor]::DarkGray
Write-Host ("`n-----------------------------STEP 6------------------------------`n")
[System.Console]::ForegroundColor = [System.ConsoleColor]::White

#Cleanup
Remove-Item -Path "$env:USERPROFILE\Downloads\KeyFiles" -Recurse -Force
Remove-Item -Path "$env:USERPROFILE\Downloads\tempinfo.txt" -Force
Remove-Item -Path "$env:USERPROFILE\Downloads\python-3.12.1-amd64.exe" -Force

Write-Host "All done! Launch KeyBot from the Desktop ot Start Menu, then use 
'!key' (or any other command you defined earlier) in your chat to test it out.
Have fun homie. Continuing with the installer will launch Key
This is what KeyBot looks like when it's running properly:"
Write-Host ("`n-----------------------------------------------------------------`n`n`n`n")
Write-Host "C:\Users\Foster\Documents\Applications\KeyBot\TwitchMarkovChain\MarkovChainBot.py:23: SyntaxWarning: invalid escape sequence '\w'
  self.link_regex = re,compile\w+\.a-z2.)
[2024-08-23 16:31:44,955] [Settings] [INFO    ] - The following keys were missing from C:\Windows\system32\settings.json: .
[2024-08-23 16:31:44,955] [Settings] [INFO    ] - These defaults of these values were used, and added to C:\Windows\system32\settings.json. Default behaviour will not change.
[2024-08-23 16:31:44,999] [TwitchWebsocket.TwitchWebsocket] [INFO    ] - Attempting to initialize websocket connection.
[2024-08-23 16:31:45,100] [TwitchWebsocket.TwitchWebsocket] [INFO    ] - Websocket connection initialized.

"

[System.Console]::ForegroundColor = [System.ConsoleColor]::Yellow
Write-Host "`nPress any key to see continue..."
[void][System.Console]::ReadKey($true)
[System.Console]::ForegroundColor = [System.ConsoleColor]::White
Start-Process -FilePath "$env:USERPROFILE\Desktop\KeyBot.lnk"

[System.Console]::ForegroundColor = [System.ConsoleColor]::Yellow
Write-Host "`nPress any key to close KeyBot Installer..."
[void][System.Console]::ReadKey($true)
exit
