# Installs ONLY the free tools that are missing (uses winget, built into Windows 11).
# Run from the project folder:  powershell -ExecutionPolicy Bypass -File setup\install-programs.ps1
$ErrorActionPreference = 'Continue'
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
  Write-Host "winget not found. Install 'App Installer' from the Microsoft Store, then re-run." -ForegroundColor Red; exit 1
}
function Has($cmd, $path) {
  if ($cmd -and (Get-Command $cmd -ErrorAction SilentlyContinue)) { return $true }
  if ($path -and (Test-Path $path)) { return $true }
  return $false
}
$tools = @(
  @{Name='Git';              Id='Git.Git';                       Cmd='git'},
  @{Name='GitHub CLI';       Id='GitHub.cli';                    Cmd='gh'},
  @{Name='Node.js LTS';      Id='OpenJS.NodeJS.LTS';             Cmd='node'},
  @{Name='VS Code';          Id='Microsoft.VisualStudioCode';    Cmd='code'},
  @{Name='Docker Desktop';   Id='Docker.DockerDesktop';          Cmd='docker'},
  @{Name='Anaconda';         Id='Anaconda.Anaconda3';            Path="$env:USERPROFILE\anaconda3\Scripts\conda.exe"},
  @{Name='QGIS';             Id='OSGeo.QGIS';                    Path='C:\Program Files\QGIS*'},
  @{Name='jq (JSON tool)';   Id='jqlang.jq';                     Cmd='jq'},
  @{Name='k6 (load tests)';  Id='k6.k6';                         Cmd='k6'},
  @{Name='Ollama (local LLM, free)'; Id='Ollama.Ollama';         Cmd='ollama'}
)
$failed = @()
foreach ($t in $tools) {
  if (Has $t.Cmd $t.Path) { Write-Host "[OK]  $($t.Name) already installed" -ForegroundColor Green; continue }
  Write-Host "[..]  Installing $($t.Name) ..." -ForegroundColor Yellow
  winget install --id $t.Id -e --accept-package-agreements --accept-source-agreements
  if ($LASTEXITCODE -ne 0) { $failed += $t.Name }
}
# VS Code extensions (free)
if (Get-Command code -ErrorAction SilentlyContinue) {
  $ext = 'ms-python.python','ms-toolsai.jupyter','ms-azuretools.vscode-docker','redhat.vscode-yaml',
         'charliermarsh.ruff','esbenp.prettier-vscode','dbaeumer.vscode-eslint','bradlc.vscode-tailwindcss',
         'eamodio.gitlens','tamasfe.even-better-toml','ms-vscode-remote.remote-wsl'
  foreach ($e in $ext) { code --install-extension $e --force | Out-Null; Write-Host "[ext] $e" }
}
Write-Host ""
if ($failed.Count) {
  Write-Host "Could not auto-install: $($failed -join ', ')" -ForegroundColor Red
  Write-Host "Run  winget search <name>  to find the exact id, or download manually (e.g. qgis.org)."
} else { Write-Host "All tools present. Close and reopen your terminals so PATH refreshes." -ForegroundColor Green }
