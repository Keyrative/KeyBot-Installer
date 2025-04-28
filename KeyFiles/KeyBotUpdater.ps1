# Set the title of the PowerShell window
$Host.UI.RawUI.WindowTitle = "KeyBot Updater"

# Download TwitchMarkovChain & KeyFiles, unzip and delete zip
#Invoke-WebRequest -Uri "https://github.com/keyrative/KeyFiles/archive/refs/heads/main.zip" -OutFile "$env:USERPROFILE\Downloads\KeyFiles.zip"
#Add-Type -AssemblyName System.IO.Compression.FileSystem
#[System.IO.Compression.ZipFile]::ExtractToDirectory("$env:USERPROFILE\Downloads\KeyFiles.zip", "$env:USERPROFILE\Downloads\KeyFiles")
#Remove-Item -Path "$env:USERPROFILE\Downloads\KeyFiles.zip"
# Download TwitchMarkovChain, Key Files, unzip and delete zip
Invoke-WebRequest -Uri "https://github.com/keyrative/KeyBot-Installer/archive/refs/heads/main.zip" -OutFile "$env:USERPROFILE\Downloads\KeyBot-Installer.zip"
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory("$env:USERPROFILE\Downloads\KeyBot-Installer.zip", "$env:USERPROFILE\Downloads\KeyBot-Installer-1")
Remove-Item -Path "$env:USERPROFILE\Downloads\KeyBot-Installer.zip"
Copy-Item -Path "$env:USERPROFILE\Downloads\KeyBot-Installer-1\KeyBot-Installer-main" -Destination "$env:USERPROFILE\Downloads\KeyBot-Installer" -Recurse
Remove-Item -Path "$env:USERPROFILE\Downloads\KeyBot-Installer-1\" -Recurse -Force
Copy-Item -Path "$env:USERPROFILE\Downloads\KeyBot-Installer\KeyFiles" -Destination "$env:USERPROFILE\Downloads\KeyFiles" -Recurse
Copy-Item -Path "$env:USERPROFILE\Downloads\KeyBot-Installer\TwitchMarkovChain" -Destination "$env:USERPROFILE\Downloads\KeyFiles\TwitchMarkovChain" -Recurse
Remove-Item -Path "$env:USERPROFILE\Downloads\KeyBot-Installer" -Recurse -Force

Write-Host "Updating Key Bot..."

#Copy and replace KeyBotInstaller, KeyBotUninstaller, KeyBotUpdater & KeyEditor
$filesToCopy = @(
    "AcctAuth3.0.ps1",
    "KeyBot.ps1",
    "key icon.ico",
    "KeyBotUninstaller.ps1",
    "KeyEditor.ps1",
    "KeyBotUpdater.ps1"
)

foreach ($file in $filesToCopy) {
    $sourcePath = "$env:USERPROFILE\Downloads\KeyFiles\$file"
    $destinationPath = "$env:USERPROFILE\Documents\Applications\KeyBot\$file"
    
    Copy-Item -Path $sourcePath -Destination $destinationPath -Recurse -Force
    
    # Verify if the file was copied successfully
    if (Test-Path -Path $destinationPath) {
        Write-Host "$file saved to $destinationPath"
    } else {
        Write-Host "Error: $file could not be copied to $destinationPath"
    }
}

$filesToCopy2 = @(
    "MarkovChainBot.py"
)

foreach ($file2 in $filesToCopy2) {
    $sourcePath = "$env:USERPROFILE\Downloads\KeyFiles\TwitchMarkovChain\$file2"
    $destinationPath = "$env:USERPROFILE\Documents\Applications\KeyBot\TwitchMarkovChain\$file2"
    
    Copy-Item -Path $sourcePath -Destination $destinationPath -Recurse -Force
    
    # Verify if the file was copied successfully
    if (Test-Path -Path $destinationPath) {
        Write-Host "$file2 saved to $destinationPath"
    } else {
        Write-Host "Error: $file2 could not be copied to $destinationPath"
    }
}

#Cleanup
Remove-Item -Path "$env:USERPROFILE\Downloads\KeyFiles" -Recurse -Force

Write-Host "`nPress any key to close Key Bot Updater..."
[void][System.Console]::ReadKey($true)
exit
