<#
.DESCRIPTION

This script takes an NMAP xml file, looks up ARIN info for each IP address and then returns a collection of objects correlating the data.

If you specify the OutCsvFile parameter, it will save the results to CSV.

Author: Jared Haight at X-Force Red

.PARAMETER SourceFile

The path to the NMAP XML file (Required)
.PARAMETER OutCsvFile

The path to save a output to in CSV format (Optional)
.EXAMPLE

Create-NmapArinCSV.ps1 -SourceFile ../output/nmap_results.xml -OutCsvFile ../processed/nmap_arin_results.csv

.LINK
https://github.com/jaredhaight/scripts/blob/master/Create-NmapArinCSV.ps1

#>

param(
  [Parameter(Mandatory = $true)]
  $SourceFile,
  $OutCsvFile  
)

[xml]$parsedXml = Get-Content $SourceFile

$hosts = $parsedXml.nmaprun.host
$results = @()
forEach ($hostEntry in $hosts) {
    $addr = $hostEntry.address.addr
    $state = $hostEntry.status.state
    try {
      $hostname = $hostEntry.hostnames.hostname.name
    }
    catch {
      $hostname = 'NOTFOUND'
    }

    [xml]$WhoIsWebRequest = (Invoke-WebRequest "http://whois.arin.net/rest/ip/$addr").content

    try {
      $orgName = $WhoIsWebRequest.net.Name
    }
    catch {
      $orgName = 'NOTFOUND'
    }

    try {
      $orgRefName = $WhoIsWebRequest.net.orgRef.name
    }
    catch {
      $orgRefName = 'NOTFOUND'
    }

    try {
      $ref = $WhoIsWebRequest.net.ref
    }
    catch {
      $ref = 'NOTFOUND'
    }
    
    forEach ($port in $hostEntry.ports.port) {
      $result = New-Object PSObject -Property @{
        IPAddress  = $addr
        HostState  = $state
        Hostnames  = $hostname
        OrgName    = $orgName
        OrgRefName = $orgRefName
        ARINRef    = $ref
        Number     = $port.portid
        Protocol   = $port.protocol
        PortState  = $port.state.state
        Service    = $port.service.name
        ServiceFP  = $port.service.servicefp
      }
      $results += $result
    }
  }

if ($OutCsvFile) {
  $results | Export-Csv -Path $OutCsvFile
}

return $results
