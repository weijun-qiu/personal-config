if (Test-Path -Path $PROFILE) {
  Move-Item -Path $PROFILE -Destination $PROFILE".bak" -Force
} 
$script_path = $(Split-Path $MyInvocation.MyCommand.Path -Parent)
$dest_dir= $(Split-Path $PROFILE -Parent)
if (!(Test-Path -Path $PROFILE)) {
    New-Item -Path $dest_dir -ItemType Directory -Force
}
Copy-Item -Path "$($script_path)\profile.ps1" -Destination $PROFILE