$singBoxRules = @{
	version = 1
	rules   = @()
}

$domainRules = @{
	domain        = @()
	domain_suffix = @()
}

$singBoxRules.rules += $domainRules

function AddDomainRules {
	param (
		[string]$url
	)

	$content = Invoke-WebRequest -Uri $url | Select-Object -ExpandProperty Content
	$lines = $content -split "`n"

	foreach ($line in $lines) {
		if ($line.StartsWith('#')) {
			continue
		}

		$startIndex = $line.IndexOf('/') + 1
		$endIndex = $line.IndexOf('/', $startIndex)
		if ($startIndex -gt 0 -and $endIndex -gt $startIndex) {
			$domain = $line.Substring($startIndex, $endIndex - $startIndex)
			
			$domainRules.domain += $domain
		}
	}
}

AddDomainRules('https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf')
AddDomainRules('https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/google.china.conf')
AddDomainRules('https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/apple.china.conf')

$singBoxRulesJson = $singBoxRules | ConvertTo-Json -Depth 3
$singBoxRulesJson | Set-Content -Path "domains.china.json"
