# Define file and folder paths
$keyBotFolderPath = "$env:USERPROFILE\Documents\Applications\KeyBot"
$desktopShortcutPath = "$env:USERPROFILE\Desktop\KeyBot.lnk"
$desktopShortcutPath2 = "$env:USERPROFILE\Desktop\KeyEditor.lnk"
$desktopShortcutPath3 = "$env:USERPROFILE\Desktop\KeyUpdater.lnk"
$startMenuShortcutPath = "$env:USERPROFILE\Documents\Pinned Folders\Start Menu Programs\KeyBot.lnk"
$startMenuShortcutPath2 = "$env:USERPROFILE\Documents\Pinned Folders\Start Menu Programs\KeyEditor.lnk"
$startMenuShortcutPath3 = "$env:USERPROFILE\Documents\Pinned Folders\Start Menu Programs\KeyUpdater.lnk"

# Check and remove KeyBot folder if it exists
if (Test-Path -Path $keyBotFolderPath) {
    Remove-Item -Path $keyBotFolderPath -Recurse -Force -Confirm:$false
} else {
}

# Check and remove desktop shortcut if it exists
if (Test-Path -Path $desktopShortcutPath) {
    Remove-Item -Path $desktopShortcutPath -Force -Confirm:$false
} else {
}

# Check and remove desktop shortcut if it exists
if (Test-Path -Path $desktopShortcutPath2) {
    Remove-Item -Path $desktopShortcutPath2 -Force -Confirm:$false
} else {
}

# Check and remove desktop shortcut if it exists
if (Test-Path -Path $desktopShortcutPath3) {
    Remove-Item -Path $desktopShortcutPath3 -Force -Confirm:$false
} else {
}

# Check and remove start menu shortcut if it exists
if (Test-Path -Path $startMenuShortcutPath) {
    Remove-Item -Path $startMenuShortcutPath -Force -Confirm:$false
} else {
}

# Check and remove start menu shortcut if it exists
if (Test-Path -Path $startMenuShortcutPath2) {
    Remove-Item -Path $startMenuShortcutPath2 -Force -Confirm:$false
} else {
}

# Check and remove start menu shortcut if it exists
if (Test-Path -Path $startMenuShortcutPath3) {
    Remove-Item -Path $startMenuShortcutPath3 -Force -Confirm:$false
} else {
}

Write-Host "KeyBot has been uninstalled."
