# Short wrapper:  .\setup\stack.ps1 up airflow cache     |  .\setup\stack.ps1 stop   |  .\setup\stack.ps1 ps
param([Parameter(Mandatory)][ValidateSet('up','stop','down','ps','logs')][string]$Action,
      [Parameter(ValueFromRemainingArguments)][string[]]$Profiles)
Set-Location (Split-Path $PSScriptRoot -Parent)
$pf = @(); if ($Action -in 'stop','down','ps','logs') { $pf = @('--profile','*') } else { foreach ($p in $Profiles) { $pf += '--profile'; $pf += $p } }
switch ($Action) { 'up' { docker compose @pf up -d } 'stop' { docker compose @pf stop } 'down' { docker compose @pf down }
                   'ps' { docker compose @pf ps } 'logs' { docker compose @pf logs -f --tail 100 } }
