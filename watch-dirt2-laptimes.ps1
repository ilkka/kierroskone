<#
.DESCRIPTION
Watch for new Dirt 2.0 laptimes in a loop and send them to the laptime API.
#>
[CmdletBinding()]
param (
	# The API endpoint URL for uploading the laptimes. For a Kierroskone instance running at https://kk.example.com the URL should be https://kk.example.com/api/laptime-import/dirt2. 
	[Parameter(Mandatory = $true)]
	[Uri]
	$ApiUrl,

	# Path to Dirt laptime recorder thingy.
	[Parameter(Mandatory = $true)]
	[System.IO.FileInfo]
	$LaptimePath
)

do {
	Write-Host "Here I would do the export command in $LaptimePath but can't remember what it is"
	Write-Host "Here I would check if the CSV changed"
	Write-Host "Uploading"
	Import-Csv -Delimiter ';' ${LaptimePath}\laptimes.csv | ConvertTo-Json -AsArray | Invoke-RestMethod -Method Post -ContentType "application/json" $ApiUrl
	Write-Host "Sleeping 10 seconds"
	Start-Sleep -Seconds 10
} while ($true)