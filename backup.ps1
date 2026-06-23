#------------------------------------------------------------------------------
# Date: 2:33 PM 6/23/2026
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

#------------------------------------------------------------------------------
# Provide the list of directories that you want backed up
# encapsulate them in "quotes".
#------------------------------------------------------------------------------
$TargetDirectories = @(
	"C:\Users\Username\Documents"
)

$Destination = Resolve-Path "~\Backup" | Select-Object -ExpandProperty Path

foreach ($Source in $TargetDirectories) {

    if (Test-Path -LiteralPath $Source) {

	$FolderName = Split-Path -Path $Source -Leaf
	$BackupPath = [System.IO.Path]::Combine($Destination, $Foldername)
        $ZipFilePath = "$Destination\$FolderName.zip"
	$null = New-Item -Path "$BackupPath" -ItemType Directory -Force
        $LongBackupPath = "\\?\$BackupPath"
        $LongZipFilePath = "\\?\$ZipFilePath"

        Write-Host "--- Copying Directory: $Source to $Destination ---" -ForegroundColor Yellow
	robocopy "$Source" "$BackupPath" /MIR /FFT /Z /XA:SH /R:3 /W:5 /NFL /XJ /XF *.crdownload *.lock *.lnk *.pst *.ost *.laccdb *.tmp *.temp /XD "node_modules" "temp" "cache"
		#/LOG:"$Destination\$FolderName.txt"
	
	Write-Host "--- Compressing Directory: $FolderName ---" -ForegroundColor Yellow
        if (Test-Path -LiteralPath $LongZipFilePath) { Remove-Item -LiteralPath $LongZipFilePath -Force }
        Write-Host "This may take a while depedning on the size of the files..." -ForegroundColor Cyan
        [System.IO.Compression.ZipFile]::CreateFromDirectory($LongBackupPath, $LongZipFilePath)

        if (Test-Path -LiteralPath "$LongZipFilePath") {
            Write-Host "Zip created successfully: $ZipFilePath" -ForegroundColor Green
            Write-Host "Cleaning up temporary folder..." -ForegroundColor Cyan
            
            # PowerShell 5.1 workaround for stubborn nested folders
            Get-ChildItem -LiteralPath "$LongBackupPath" -Recurse -Force | Remove-Item -Recurse -Force
            Remove-Item -LiteralPath "$LongBackupPath" -Force
            
        } else {
            Write-Warning "Zip file creation failed. Temporary folder left intact at: $BackupPath"
        }
        

    } else {
        Write-Warning "Directory not found or inaccessible: $Source"
    }
}

if (Test-Path -LiteralPath $Destination) {
    Write-Host "Opening backup directory..." -ForegroundColor Green
    Invoke-Item -LiteralPath $Destination
}