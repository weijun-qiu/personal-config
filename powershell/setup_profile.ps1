if (Test-Path -Path $PROFILE) {
  Move-Item -Path $PROFILE -Destination $PROFILE".bak" -Force
} 
$script_path = $(Split-Path $MyInvocation.MyCommand.Path -Parent)
Copy-Item -Path "$($script_path)\profile.ps1" -Destination $PROFILE