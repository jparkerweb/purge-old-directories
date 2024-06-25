param(
    [string]$FolderPath,
    [switch]$Force
)

# Function to delete all files in a folder using robocopy
function Purge-Files {
    param(
        [string]$Folder
    )

    # Ensure an empty directory exists (if not, create it)
    $emptyDir = "c:\empty"
    if (-not (Test-Path -Path $emptyDir)) {
        New-Item -ItemType Directory -Path $emptyDir
    }
    else {
        # Ensure the directory is truly empty
        Remove-Item -Path "$emptyDir\*" -Recurse -Force
    }

    # Run the robocopy command
    robocopy "c:\empty" $Folder /purge /w:1 /r:1

    # Check if the folder is empty and delete it if it is
    if (Is-FolderEmpty -Folder $Folder) {
        Remove-Item -Path $Folder -Force
        Write-Host "The folder '$Folder' has been deleted as it was empty after purging files."
    } else {
        Write-Host "The folder '$Folder' is not empty after purging files."
    }
}

# Function to check if a folder is empty
function Is-FolderEmpty {
    param(
        [string]$Folder
    )
    $items = Get-ChildItem -Path $Folder
    return $items.Count -eq 0
}

# If folder path is provided as an argument
if ($FolderPath) {
    if (-not (Test-Path -Path $FolderPath)) {
        Write-Host "The provided folder path does not exist: $FolderPath"
        exit
    }

    if ($Force) {
        # Purge files without any user interaction
        Purge-Files -Folder $FolderPath
    }
    else {
        # Display the initial message
        Write-Host "`nThis script will delete all files in the destination directory using robocopy purge:"
        Write-Host "$FolderPath"
        Write-Host ""
        Write-Host "After the files are deleted, the destination directory will be checked to see if it is empty."
        Write-Host "If the directory is empty, it will be deleted as well.`n"
        Write-Host "WARNING: This operation cannot be undone.`n"
        Write-Host ""

        # Pause and wait for the user to press Enter
        Read-Host "Press Enter to continue or Ctrl+C to cancel..."
        Purge-Files -Folder $FolderPath
    }
}
else {
    # Display the initial message
    Write-Host "`nThis script will delete all files in the destination directory using robocopy purge"
    Write-Host "You will be asked to select the destination directory in the next step.`n"
    Write-Host ""
    Write-Host "After the files are deleted, the destination directory will be checked to see if it is empty."
    Write-Host "If the directory is empty, it will be deleted as well.`n"
    Write-Host "WARNING: This operation cannot be undone.`n"
    Write-Host ""

    if (-not $Force) {
        # Pause and wait for the user to press Enter
        Read-Host "Press Enter to continue or Ctrl+C to cancel..."
    }

    # Open a file select dialog to ask the user to select a folder
    Add-Type -AssemblyName System.Windows.Forms
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Select the folder you want to purge files from"
    $result = $folderBrowser.ShowDialog()

    # Check if the user pressed the OK button
    if ($result -eq 'OK') {
        $selectedFolder = $folderBrowser.SelectedPath
        Write-Host "You have selected: $selectedFolder"
        Purge-Files -Folder $selectedFolder
    }
    else {
        Write-Host "Operation cancelled by user."
    }
}
