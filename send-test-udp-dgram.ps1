<#
.DESCRIPTION
Send test UDP datagrams.
#>
[CmdletBinding()]
param (
  [Parameter(Mandatory = $true)]
  [string]
  $Address,

  [Parameter(Mandatory = $true)]
  [int]
  $Port,

  [Parameter(Mandatory = $true)]
  [string]
  $Message
)

$ip = [System.Net.Dns]::GetHostAddresses($Address)
$endpoint = New-Object System.Net.IPEndPoint([System.Net.IPAddress]::Parse($ip), $Port)
$socket = New-Object System.Net.Sockets.UdpClient

$encodedMsg = [Text.Encoding]::ASCII.GetBytes($Message)
$socket.Send($encodedMsg, $encodedMsg.Length, $endpoint)
$socket.Close()
