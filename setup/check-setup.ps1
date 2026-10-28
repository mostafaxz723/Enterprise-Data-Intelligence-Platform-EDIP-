# Full health check: programs, Docker, ports, conda envs, Python libraries. Changes nothing.
#   powershell -ExecutionPolicy Bypass -File setup\check-setup.ps1
param([ValidateSet("all","data","web")][string]$Role = "all")
Set-Location (Split-Path $PSScriptRoot -Parent)
$script:bad = 0
function Show($ok, $msg, $fix) {
  if ($ok) { Write-Host "[OK]      $msg" -ForegroundColor Green }
  else { Write-Host "[MISSING] $msg" -ForegroundColor Red; if ($fix) { Write-Host "          fix: $fix" -ForegroundColor DarkYellow }; $script:bad++ }
}
function Ver($cmd, $arg) { try { (& $cmd $arg 2>&1 | Select-Object -First 1) } catch { '' } }

Write-Host "`n== Programs ==" -ForegroundColor Cyan
foreach ($t in @(@('git','--version'),@('node','--version'),@('npm','--version'),@('docker','--version'),@('code','--version'))) {
  $has = [bool](Get-Command $t[0] -ErrorAction SilentlyContinue)
  Show $has "$($t[0])  $(if($has){Ver $t[0] $t[1]})" "run setup\install-programs.ps1"
}
Show ([bool](Get-ChildItem 'C:\Program Files\QGIS*' -ErrorAction SilentlyContinue)) 'QGIS' 'winget install OSGeo.QGIS  (or qgis.org)'
foreach ($o in 'gh','jq','ollama','k6') { if (-not (Get-Command $o -ErrorAction SilentlyContinue)) { Write-Host "[optional] $o not installed (only if you need it)" -ForegroundColor DarkGray } }
$conda = Join-Path $env:USERPROFILE 'anaconda3\Scripts\conda.exe'
if (-not (Test-Path $conda)) { $c = Get-Command conda -ErrorAction SilentlyContinue; if ($c) { $conda = $c.Source } }
Show (Test-Path $conda) "conda  $(if(Test-Path $conda){& $conda --version})" 'install Anaconda'

if ($Role -eq "web") { Write-Host "`n== Web ==" -ForegroundColor Cyan; Show (Test-Path web\node_modules) "web dependencies installed (npm install)" "run: cd web ; npm install"; if ($script:bad -eq 0) { Write-Host "WEB ROLE READY. Run: cd web ; npm run dev" -ForegroundColor Green } else { Write-Host "$($script:bad) item(s) need attention." -ForegroundColor Yellow }; exit }
Write-Host "`n== Docker ==" -ForegroundColor Cyan
docker info *> $null; $up = ($LASTEXITCODE -eq 0)
Show $up 'Docker engine running' 'open Docker Desktop and wait for "Engine running"'
if ($up) {
  docker compose version *> $null; Show ($LASTEXITCODE -eq 0) 'docker compose v2'
  docker compose --profile "*" config -q 2>$null; Show ($LASTEXITCODE -eq 0) 'docker-compose.yml is valid'
  $have = docker images --format '{{.Repository}}:{{.Tag}}'
  foreach ($img in 'postgis/postgis:16-3.4','egy-airflow:2.8.1','postgres:15-alpine') {
    Show ($have -contains $img) "image $img" 'powershell -File setup\docker-prepare.ps1 -Light'
  }
  $opt = 'redis:7-alpine','apache/kafka:3.7.0','prom/prometheus:v2.50.1','grafana/grafana:10.3.3','metabase/metabase:latest','ghcr.io/mlflow/mlflow:latest','ghcr.io/maplibre/martin:latest','pgvector/pgvector:pg16','egy-dbt:dev','egy-api:dev','mongo:7','clickhouse/clickhouse-server:latest'
  $notYet = $opt | Where-Object { $have -notcontains $_ }
  if ($notYet) { Write-Host "[optional] not downloaded yet ($($notYet.Count)): they download when first used, or run docker-prepare.ps1 without -Light" -ForegroundColor DarkGray }
  Write-Host "Running containers now:"; docker ps --format "  {{.Names}}  ({{.Status}})"
}

Write-Host "`n== Ports (a busy port means another program uses it) ==" -ForegroundColor Cyan
$ports = @{5433='PostGIS';8080='Airflow';6379='Redis';9092='Kafka';9090='Prometheus';3001='Grafana';3002='Metabase';5000='MLflow';3003='Martin';8000='API';3000='Next.js';27018='Mongo';8123='ClickHouse';9010='ClickHouse native'}
foreach ($p in $ports.Keys | Sort-Object) {
  $busy = Get-NetTCPConnection -LocalPort $p -State Listen -ErrorAction SilentlyContinue
  if ($busy) { Write-Host "[BUSY]    port $p ($($ports[$p])) is in use now (fine if that is our container)" -ForegroundColor Yellow }
}

Write-Host "`n== Machine ==" -ForegroundColor Cyan
$ram = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory/1GB,1)
Write-Host "RAM: $ram GB"
Show (Test-Path "$env:USERPROFILE\.wslconfig") '.wslconfig (caps Docker memory)' 'see docs/PERFORMANCE.md item 1 (caps Docker memory)'
Show (Test-Path .env) '.env file' 'Copy-Item .env.example .env'

Show (Test-Path web\node_modules) 'web dependencies (npm install)' 'cd web ; npm install'
Write-Host "`n== Python environments ==" -ForegroundColor Cyan
if (Test-Path $conda) {
  $envs = & $conda env list
  Show ($envs -match 'egypt-energy') 'conda env egypt-energy' 'setup\create-envs.ps1'
  if ($envs -match 'egypt-energy') { & $conda run -n egypt-energy --no-capture-output python setup\check_python.py; if ($LASTEXITCODE -ne 0) { $script:bad++ } }
  if ($envs -match 'egypt-ai') { & $conda run -n egypt-ai --no-capture-output python setup\check_python.py --ai }
  else { Write-Host '[info]    egypt-ai env not created yet (only needed for the chatbot): 01-create-envs.ps1 -WithAI' }
}
Write-Host ""
if ($script:bad -eq 0) { Write-Host 'EVERYTHING IS READY.' -ForegroundColor Green } else { Write-Host "$($script:bad) item(s) need attention (see fixes above)." -ForegroundColor Yellow }
