<#
.SYNOPSIS
    Installs matlab-batch on a Windows system.

.DESCRIPTION
    Downloads the matlab-batch executable.
    Creates a directory to place the executable into.
    Adds the executable onto the user PATH.

.PARAMETER InstallLocation
    Specifies the location where matlab-batch will be downloaded to and installed in.
    Defaults to $ProgramFiles\MathWorks.

.PARAMETER Help
    Shows a help message for the install script if present.

.EXAMPLE
    Install-Batch
    Install-Batch -Help
    Install-Batch -InstallLocation C:\MyPrograms

.NOTES
    Copyright 2024 The MathWorks, Inc.
#>
param (
        [string]$InstallLocation='C:\Program Files\MathWorks',
        [switch]$Help
    )

$DEFAULT_DOWNLOAD_BASE_URL = 'https://ssd.mathworks.com/supportfiles/ci/matlab-batch/v1/win64/matlab-batch.exe'

# Set strict error handling
$ErrorActionPreference = 'Stop'

# Show help
function Show-Help {
    Write-Output "Usage: install-matlab-batch.ps1 [parameters]"
    Write-Output ""
    Write-Output "Options:"
    Write-Output "  -Help               Display this help message."
    Write-Output '  -InstallLocation    Specify an install location. Defaults to $ProgramFiles\MathWorks.'
    Write-Output ""
}

# Function to download the matlab-batch executable binary
function Download {
    param (
        [string]$Url,
        [string]$Filename
    )
    Invoke-WebRequest -Uri $Url -OutFile $Filename 
}

function Install-MatlabBatch {   
    param (
        [string]$InstallDirectory
    )

    Write-Output 'Starting Install-MatlabBatch...'

    # Resolve $InstallDirectory to an absolute path
    $InstallDirectory = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine((Get-Location), $InstallDirectory)) + "\matlab-batch"

    # Create standard location for install if it does not exist
    New-Item -ItemType Directory -Force -Path "$InstallDirectory"

    # Define the default download URL
    $BaseUrl = $DEFAULT_DOWNLOAD_BASE_URL
    try {
        Download "$BaseUrl" "$InstallDirectory\matlab-batch.exe"
    }
    catch {
        Write-Host "Failed to download matlab-batch ($($_.Exception.Message))"
        exit 1
    }

    # Add the installation directory to the system PATH 
    $SystemPath = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine)
    $PathEntries = $SystemPath.Split(';')

    # Check for existing entries for the matlab-batch folder
    $ExistingEntries = @($PathEntries | Where-Object { $_ -like "*matlab-batch*" })

    if ($ExistingEntries.Count -eq 0) {
        # No entry for matlab-batch on PATH
        $NewPath = $SystemPath + ';' + $InstallDirectory
        [System.Environment]::SetEnvironmentVariable('Path', $NewPath, [System.EnvironmentVariableTarget]::Machine)
        Write-Output "Added new installation directory to PATH. You will have to start a fresh PowerShell session to find it on PATH."
    } else {
        if ($ExistingEntries -contains $InstallDirectory) {
            # There are matlab-batch entries on PATH and an entry matches InstallLocation
            $FirstEntry = $ExistingEntries[0]

            if ($FirstEntry -ne $InstallDirectory) {
                # Matching entry is not at the start of the PATH, move it to the first entry
                $PathEntries = $PathEntries | Where-Object { $_ -ne $InstallDirectory }
                $FirstMatlabBatchIndex = [Array]::IndexOf($PathEntries, $FirstEntry)
                $PathEntries = $PathEntries[0..($FirstMatlabBatchIndex-1)] + $InstallDirectory + $PathEntries[$FirstMatlabBatchIndex..($PathEntries.Length-1)]
                $NewPath = $PathEntries -join ';'
                [System.Environment]::SetEnvironmentVariable('Path', $NewPath, [System.EnvironmentVariableTarget]::Machine)
                Write-Output "Moved current installation directory to the first position among matlab-batch entries. You will have to start a fresh PowerShell session to find it on PATH."
            } else {
                # Matching entry is the first matlab-batch entry on PATH, do nothing
                Write-Output "The current installation directory is already the first entry on PATH. No changes made."
            }
        } else {
            # There are matlab-batch entries on PATH and no entry matches InstallLocation
            $FirstEntry = $ExistingEntries[0]
            $FirstMatlabBatchIndex = [Array]::IndexOf($PathEntries, $FirstEntry)
            $PathEntries = $PathEntries[0..($FirstMatlabBatchIndex-1)] + $InstallDirectory + $PathEntries[$FirstMatlabBatchIndex..($PathEntries.Length-1)]
            $NewPath = $PathEntries -join ';'
            [System.Environment]::SetEnvironmentVariable('Path', $NewPath, [System.EnvironmentVariableTarget]::Machine)
            Write-Output "Added new installation directory to the beginning of the matlab-batch entries. You will have to start a fresh PowerShell session to find it on PATH."
        }
    }
    
    Write-Output "Done with Install-MatlabBatch."
}

try {
    # Check if PowerShell is running as Administrator
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $isAdministrator = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    if ($Help) {
        Show-Help
        exit 0
    }

    if ($isAdministrator) {
        Install-MatlabBatch -InstallDirectory $InstallLocation
    } else {
        Write-Host "PowerShell is not running as Administrator. Please run PowerShell as Administrator to proceed with installation."
    }
}
catch {
    $ScriptPath = $MyInvocation.MyCommand.Path
    Write-Output "ERROR - An error occurred while running script: $ScriptPath. Error: $_"
    throw
}
