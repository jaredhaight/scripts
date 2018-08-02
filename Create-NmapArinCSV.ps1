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