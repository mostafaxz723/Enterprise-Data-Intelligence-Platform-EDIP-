# Creates/updates the conda environments. Works from plain PowerShell (no `conda init` needed).
#   powershell -ExecutionPolicy Bypass -File setup\create-envs.ps1            # main env
#   powershell -ExecutionPolicy Bypass -File setup\create-envs.ps1 -WithAI    # + AI env (heavy, ~3-4 GB)
param([switch]$WithAI)
$conda = Join-Path $env:USERPROFILE 'anaconda3\Scripts\conda.exe'
if (-not (Test-Path $conda)) { $c = Get-Command conda -ErrorAction SilentlyContinue; if ($c) { $conda = $c.Source } else { Write-Host 'conda not found' -ForegroundColor Red; exit 1 } }
Set-Location (Split-Path $PSScriptRoot -Parent)
function EnvExists($n) { (& $conda env list) -match "(^|\s)$n(\s|$)" }

if (EnvExists 'egypt-energy') { Write-Host '>> Updating egypt-energy (adds what is missing, removes nothing)' -ForegroundColor Cyan
  & $conda env update -n egypt-energy -f environment.yml }
else { Write-Host '>> Creating egypt-energy' -ForegroundColor Cyan
  & $conda env create -f environment.yml }

if ($WithAI) {
  if (EnvExists 'egypt-ai') { & $conda env update -n egypt-ai -f environment-ai.yml }
  else { & $conda env create -f environment-ai.yml }
}
Write-Host "`nNext: powershell -ExecutionPolicy Bypass -File setup\check-setup.ps1" -ForegroundColor Green
