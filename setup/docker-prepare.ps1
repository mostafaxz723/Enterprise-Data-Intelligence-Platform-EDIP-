# Prepares Docker: creates .env, validates compose, pre-downloads images and builds custom ones.
# Nothing is STARTED here, so no RAM is used afterwards.
#   -Light : only PostGIS + Airflow (about 3 GB download)   |   default: everything (about 6-7 GB)
param([switch]$Light)
Set-Location (Split-Path $PSScriptRoot -Parent)
docker info *> $null
if ($LASTEXITCODE -ne 0) { Write-Host 'Docker Desktop is not running. Start it and wait for "Engine running".' -ForegroundColor Red; exit 1 }
if (-not (Test-Path .env)) { Copy-Item .env.example .env; Write-Host 'Created .env from .env.example' -ForegroundColor Yellow }
foreach ($d in 'data_engineering\dags','infra\airflow\logs','infra\airflow\plugins','data_engineering\lake\raw','data_engineering\lake\processed') { New-Item -ItemType Directory -Force -Path $d | Out-Null }

docker compose --profile "*" config -q
if ($LASTEXITCODE -ne 0) { Write-Host 'docker-compose.yml has an error (see above).' -ForegroundColor Red; exit 1 }
Write-Host 'compose file is valid' -ForegroundColor Green

if ($Light) {
  docker compose --profile airflow pull --ignore-buildable
  if ($LASTEXITCODE -ne 0) { Write-Host "`nPULL FAILED. Send the last 30 lines above." -ForegroundColor Red; exit 1 }
  docker compose --profile airflow build
  if ($LASTEXITCODE -ne 0) { Write-Host "`nBUILD FAILED. Send the last 30 lines above." -ForegroundColor Red; exit 1 }
} else {
  # pull every image ONE BY ONE so a single missing image does not stop everything
  $imgs = docker compose --profile "*" config --images | Where-Object { $_ -and ($_ -notlike 'egy-*') } | Sort-Object -Unique
  $failed = @()
  foreach ($i in $imgs) {
    Write-Host "`n>> pulling $i" -ForegroundColor Cyan
    docker pull $i
    if ($LASTEXITCODE -ne 0) { $failed += $i }
  }
  docker compose --profile "*" build
  if ($LASTEXITCODE -ne 0) { Write-Host "`nBUILD FAILED. Send the last 30 lines above." -ForegroundColor Red; exit 1 }
  if ($failed.Count) { Write-Host "`nCould not pull (send me this list): $($failed -join ', ')" -ForegroundColor Yellow }
}
Write-Host "`nDone. Nothing is running. Start the core DB:  docker compose up -d" -ForegroundColor Green
docker images --format "table {{.Repository}}`t{{.Tag}}`t{{.Size}}"
