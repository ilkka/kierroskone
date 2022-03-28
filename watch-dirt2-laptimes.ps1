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
	$TimeRecorderPath,

	# Kierroskone laptimes API token
	[Parameter(Mandatory = $true)]
	[String]
	$ApiToken
)

$LaptimesCsvPath = "${PSScriptRoot}.\laptimes.csv"
$CsvExportPath = "${TimeRecorderPath}\snapshot.csv"

do {
	Write-Host "Export current times"
	# The export bat has the "wait for enter" bit so we just duplicate its functionality here
	Push-Location $TimeRecorderPath
	& ".\sqlite3.exe" -init ".\export-laptimes.sql" ".\dirtrally-laptimes.db" .exit
	Pop-Location
	
	Write-Host "Check for new times"
	$doUpload = $false
	# Should we upload? Check that the export was non-empty and that it's different from the previous
	# file ($LaptimesCsvPath)
	try {
		# Upload non-empty? At least 2 lines (header + 1 data line)
		if ((Get-Content $CsvExportPath | Measure-Object).Count -gt 1) {
			# Upload different?
			if ((Compare-Object (Get-Content $LaptimesCsvPath) (Get-Content $CsvExportPath) | Measure-Object).Count -gt 0) {
				$doUpload = $true
			}
		}
	}
	catch {
		# Probably missing stored previous laptimes.csv -> first run
		$doUpload = $true
	}
	
	# TODO: use compare-object to get only the _new_ times and upload those
	if ($doUpload) {
		Copy-Item -Path $CsvExportPath -Destination $LaptimesCsvPath -Force
		Write-Host "Uploading"
		Import-Csv -Delimiter ';' ${LaptimesCsvPath} | ConvertTo-Json -AsArray | Invoke-RestMethod -Method Post -ContentType "application/json; charset=utf-8" -Headers @{"x-api-token" = $ApiToken } $ApiUrl
	}
	else {
		Write-Host "No change, skipping upload"
	}
	Write-Host "Sleeping 10 seconds"
	Start-Sleep -Seconds 10
} while ($true)