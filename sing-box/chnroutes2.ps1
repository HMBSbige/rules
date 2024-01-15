$url = 'https://raw.githubusercontent.com/misakaio/chnroutes2/master/chnroutes.txt'
$content = Invoke-WebRequest -Uri $url | Select-Object -ExpandProperty Content

$singBoxRules = @{
	version = 1
	rules   = @()
}

$ipRule = @{
	ip_cidr = @()
}

$singBoxRules.rules += $ipRule

$lines = $content -split "`n"
foreach ($line in $lines) {
	if ($line.StartsWith('#')) {
		continue
	}
	if (!$line.Contains('/')) {
		continue
	}

	$ipRule.ip_cidr += $line
}

$singBoxRulesJson = $singBoxRules | ConvertTo-Json -Depth 3
$singBoxRulesJson | Set-Content -Path "chnroutes2.json"
