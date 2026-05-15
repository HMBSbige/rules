$url = 'https://raw.githubusercontent.com/ipverse/as-ip-blocks/master/as/32590/aggregated.json'
$json = Invoke-WebRequest -Uri $url | ConvertFrom-Json

$singBoxRules = @{
	version = 4
	rules   = @()
}

$ipRule = @{
	ip_cidr = @()
}

$singBoxRules.rules += $ipRule

$ipv4 = $json.prefixes.ipv4

foreach ($ip in $ipv4) {
	$ipRule.ip_cidr += $ip
}

$ipv6 = $json.prefixes.ipv6

foreach ($ip in $ipv6) {
	$ipRule.ip_cidr += $ip
}

$singBoxRulesJson = $singBoxRules | ConvertTo-Json -Depth 3
$singBoxRulesJson | Set-Content -Path "as32590.json"
