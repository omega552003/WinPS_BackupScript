# WinPS_BackupScript
Windows PowerShell script that backs up files into zip archives.

## What it does:
1. Copies directory(s) to a local cache
2. Compresses each directory in to a Zip file of the same name
3. Deletes the local cached folder
## Features:
- Handles multiple directories and network paths
- Directories: `C:\Forlder\Sub-Folder`
- Network Paths: `\\Server\SharedFolder\Subfolder`
- UTF-8/UTF-16 encoding, handles atypical folder and filenames with special characters or emojis.
- Bypasses 260 character file path limit.
- Bypasses >2GB zip file limit.
- Resumable, if the script is interrupted it will continue where it left off.
- Only removes local cache when a Zip file has been successfully created.
## Instructions:
1. Download the attached backup.ps1 PowerShell script.
2. Edit the script, change the list of "TargetDirectories" and save the file.
3. Open Terminal and start a PowerShell session (typically the default).
4. Navigate to where you placed the script; `cd ~\Downloads`
5. Run the script with the command `.\backup.ps1`
If the script is interrupted, just repeat steps from #3.
