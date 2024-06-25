# PowerShell for Purging Old Directories

These two PowerShell scripts were designed to help manage and clean up by purging old directories.

## purge-files-in-folder.ps1

### Description

`purge-files-in-folder.ps1` is a PowerShell script that deletes all files in a specified folder using the `robocopy /purge` command. If the folder is empty after the purge, the script deletes the folder as well.

### Usage

```powershell
.\purge-files-in-folder.ps1 -FolderPath <path> [-Force]
```

### Parameters

- `-FolderPath`: The path to the folder you want to purge.
- `-Force`: Optional. Runs the script without requiring user confirmation.

### Example

```powershell
.\purge-files-in-folder.ps1 -FolderPath "C:\Example\Path" -Force
```

### Notes

- Ensure you have the necessary permissions to delete files and folders.



---



## purge-old-folders.ps1

### Description

`purge-old-folders.ps1` is a PowerShell script that calls `purge-files-in-folder.ps1` for directories older than a specified number of months. It helps in cleaning up old directories within a target path in batches.

### Usage

```powershell
.\purge-old-folders.ps1 -TargetPath <path> -MonthsOld <number of months> [-Force]
.\purge-old-folders.ps1 -h | --help
```

### Parameters

- `-TargetPath`: The path to the parent directory containing directories to purge.
- `-MonthsOld`: The age of directories (in months) to purge.
- `-Force`: Optional. Runs the script without requiring user confirmation.
- `-h` or `--help`: Displays usage instructions.

### Example

```powershell
.\purge-old-folders.ps1 -TargetPath "C:\Example\Path" -MonthsOld 6 -Force
```

### Interactive Usage

If no parameters are provided, the script will:

1. Open a file browser dialog to select the target directory.
2. Prompt the user to enter the number of months.
3. Confirm the target path and months old parameters unless `-Force` is specified.

### Notes

- Ensure you have the necessary permissions to delete files and folders.
