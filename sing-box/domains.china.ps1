$url = 'https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf'
$content = Invoke-WebRequest -Uri $url | Select-Object -ExpandProperty Content

$singBoxRules = @{
	version = 1
	rules   = @()
}

$domainRules = @{
	domain        = @()
	domain_suffix = @()
}

$singBoxRules.rules += $domainRules

$lines = $content -split "`n"
foreach ($line in $lines) {
	$startIndex = $line.IndexOf('/') + 1
	$endIndex = $line.IndexOf('/', $startIndex)
	if ($startIndex -gt 0 -and $endIndex -gt $startIndex) {
		$domain = $line.Substring($startIndex, $endIndex - $startIndex)

		$domainRules.domain += $domain
		$domainRules.domain_suffix += ".$domain"
	}
}

$singBoxRulesJson = $singBoxRules | ConvertTo-Json -Depth 3
$singBoxRulesJson | Set-Content -Path "domains.china.json"
