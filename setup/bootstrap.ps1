# ONE command that prepares a teammate's machine. Safe to re-run any time; never deletes anything.
#   powershell -ExecutionPolicy Bypass -File setup\bootstrap.ps1                 # everything (role: all)
#   powershell -ExecutionPolicy Bypass -File setup\bootstrap.ps1 -Role web       # light: only the website (8 GB laptops)
#   powershell -ExecutionPolicy Bypass -File setup\bootstrap.ps1 -Role data      # data engineering: conda + Docker
# extra switches: -Full (pull every optional Docker image, 6-7 GB)  -WithAI (chatbot env, 3-4 GB)  -SkipDocker
param([ValidateSet('all','data','web')][string]$Role = 'all', [switch]$Full, [switch]$WithAI, [switch]$SkipDocker)
Set-Location (Split-Path $PSScriptRoot -Parent)
function Need($cmd, $url) { if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) { Write-Host "Missing: $cmd -> $url" -ForegroundColor Red; return $true } return $false }
$stop = $false
$stop = (Need 'git' 'https://git-scm.com') -or $stop
if ($Role -in 'all','web') { $stop = (Need 'node' 'https://nodejs.org (LTS)') -or $stop }
if ($Role -in 'all','data') {
  if (-not $SkipDocker) { $stop = (Need 'docker' 'https://www.docker.com/products/docker-desktop') -or $stop }
  $conda = Join-Path $env:USERPROFILE 'anaconda3\Scripts\conda.exe'
  if (-not (Test-Path $conda)) { $c = Get-Command conda -ErrorAction SilentlyContinue; if ($c) { $conda = $c.Source } else { Write-Host 'Missing: Anaconda -> https://www.anaconda.com/download' -ForegroundColor Red; $stop = $true } }
}
if ($stop) { Write-Host "`nInstall the missing program(s), reopen PowerShell, then run this script again." -ForegroundColor Yellow; exit 1 }
if (-not (Test-Path .env)) { Copy-Item .env.example .env; Write-Host 'Created .env from .env.example' -ForegroundColor Yellow }

if ($Role -in 'all','data') {
  Write-Host "`n[1] Python environment: egypt-energy" -ForegroundColor Cyan
  if ($WithAI) { & "$PSScriptRoot\create-envs.ps1" -WithAI } else { & "$PSScriptRoot\create-envs.ps1" }
  if (Test-Path .git) { & $conda run -n egypt-energy pre-commit install }
  if (-not $SkipDocker) {
    Write-Host "`n[2] Docker images (nothing is started)" -ForegroundColor Cyan
    if ($Full) { & "$PSScriptRoot\docker-prepare.ps1" } else { & "$PSScriptRoot\docker-prepare.ps1" -Light }
  }
}
if ($Role -in 'all','web') {
  Write-Host "`n[3] Website dependencies (npm install)" -ForegroundColor Cyan
  Push-Location web; npm install; Pop-Location
}
Write-Host "`n[4] Verification" -ForegroundColor Cyan
& "$PSScriptRoot\check-setup.ps1" -Role $Role
