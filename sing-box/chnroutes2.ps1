$url = 'https://raw.githubusercontent.com/misakaio/chnroutes2/master/chnroutes.txt'
$content = Invoke-WebRequest -Uri $url | Select-Object -ExpandProperty Content
$url6 = 'https://raw.githubusercontent.com/gaoyifan/china-operator-ip/ip-lists/china6.txt'
$content6 = Invoke-WebRequest -Uri $url6 | Select-Object -ExpandProperty Content

$singBoxRules = @{
	version = 2
	rules   = @()
}

$ipRule = @{
	ip_cidr = @()
}

$singBoxRules.rules += $ipRule

$lines = $content -split "`n"
$lines += $content6 -split "`n"
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
