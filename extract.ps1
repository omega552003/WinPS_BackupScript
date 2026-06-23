[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, HelpMessage = "The full path to the .zip file you want to extract.")]
    [string]$ZipPath,

    [Parameter(Mandatory = $true, HelpMessage = "The folder path where the files should be extracted.")]
    [string]$ExtractPath
)

#------------------------------------------------------------------------------
# Date: 3:58 PM 6/23/2026
# Author/Reviewer: omega552003
# Generative Ai: Gemini Enterprise (Gemini 1.5 family)
#==============================================================================
# You might need to run this command: 
#
# PowerShell.exe -ExecutionPolicy Bypass -File "C:\Scripts\myscript.ps1"
#
# Changing "C:\Scripts\myscript.ps1" to the path and name of this script
#------------------------------------------------------------------------------

[Console]::InputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
Add-Type -Assembly System.IO.Compression.FileSystem

try {
    $ResolvedZip = Resolve-Path -LiteralPath $ZipPath | Select-Object -ExpandProperty Path
    $ResolvedExtract = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ExtractPath)
} catch {
    Write-Error "Failed to resolve input paths. Please ensure the paths are correct and accessible."
    return
}

$LongZipPath = "\\?\$ResolvedZip"
$LongExtractPath = "\\?\$ResolvedExtract"

if (-not (Test-Path -LiteralPath $LongExtractPath)) {
    Write-Host "Creating destination directory..." -ForegroundColor Cyan
    $null = New-Item -Path $LongExtractPath -ItemType Directory -Force
}

Write-Host "Extracting archive: $ResolvedZip" -ForegroundColor Yellow
Write-Host "Destination: $ResolvedExtract" -ForegroundColor Yellow
Write-Host "Extracting (this may take several minutes)..." -ForegroundColor Cyan
try {
    [System.IO.Compression.ZipFile]::ExtractToDirectory($LongZipPath, $LongExtractPath)
    Write-Host "Success! Extraction complete." -ForegroundColor Green
    
    # Automatically open the extracted folder
    Invoke-Item -LiteralPath $ResolvedExtract
} catch {
    Write-Error "Extraction failed! Error details: $_"
}