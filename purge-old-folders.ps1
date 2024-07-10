param(
    [string]$TargetPath,
    [int]$MonthsOld,
    [switch]$h,
    [switch]$help,
    [switch]$Force
)

# Function to get directories older than specified months
function Get-OldDirectories {
    param(
        [string]$Path,
        [int]$Months
    )
    
    $thresholdDate = (Get-Date).AddMonths(-$Months)
    Write-Host "Threshold date for filtering directories: $thresholdDate"

    Get-ChildItem -Path $Path -Directory | ForEach-Object {
        Write-Host "Checking directory: $($_.FullName), LastWriteTime: $($_.LastWriteTime)"
        if ($_.LastWriteTime -lt $thresholdDate) {
            Write-Host "Directory $($_.FullName) is older than $Months months."
            $_
        } else {
            Write-Host "Directory $($_.FullName) is not older than $Months months."
        }
    }
}

# Function to show usage instructions
function Show-Usage {
    Write-Host "Usage: .\purge-old-folders.ps1 -TargetPath <path> -MonthsOld <number of months> [-Force]"
    Write-Host "Example: .\purge-old-folders.ps1 -TargetPath C:\Example\Path -MonthsOld 6 -Force"
}

# Show usage instructions if -h, /h, or --help is passed
if ($h -or $help) {
    Show-Usage
    exit
}

# If no parameters are provided, open a file browser dialog to select the target directory
if (-not $TargetPath) {
    Add-Type -AssemblyName System.Windows.Forms
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Select the target folder to purge old directories from"
    $result = $folderBrowser.ShowDialog()

    if ($result -eq 'OK') {
        $TargetPath = $folderBrowser.SelectedPath
    } else {
        Write-Host "Operation cancelled by user."
        exit
    }
}

# If no months old is provided, prompt the user to enter a value
if (-not $MonthsOld) {
    $MonthsOld = Read-Host "Enter the number of months old (0-36)"
    
    # Validate the entered months old value
    while (-not [int]::TryParse($MonthsOld, [ref]$null) -or $MonthsOld -lt 0 -or $MonthsOld -gt 36) {
        Write-Host "Please enter a valid number between 0 and 36."
        $MonthsOld = Read-Host "Enter the number of months old (0-36)"
    }
    $MonthsOld = [int]$MonthsOld
}

# Check if the provided target path exists
if (-not (Test-Path -Path $TargetPath)) {
    Write-Host "The provided target path does not exist: $TargetPath"
    exit
}

# Confirm the target path and months old parameters
if (-not $Force) {
    Write-Host "`nTarget Path: $TargetPath"
    Write-Host "Months Old: $MonthsOld"
    Write-Host "Press Enter to continue or Ctrl+C to cancel..."
    Read-Host
}

# Get all directories older than the specified number of months
$oldDirectories = Get-OldDirectories -Path $TargetPath -Months $MonthsOld
$numDirectories = $oldDirectories.Count
if ($numDirectories -gt 0) {
    # Shuffle the directories
    $shuffledDirectories = $oldDirectories | Get-Random -Count $oldDirectories.Count
    Write-Host $shuffledDirectories
    
    # Process each old directory
    foreach ($dir in $shuffledDirectories) {
        Write-Host "Processing directory: $($dir.FullName)"
        .\purge-files-in-folder.ps1 -FolderPath $dir.FullName -Force
    }
} else {
    Write-Host "No directories older than $MonthsOld months were found."
}

Write-Host "Completed processing of old directories."
