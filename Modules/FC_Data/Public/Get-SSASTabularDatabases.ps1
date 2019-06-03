﻿function Get-SSASTabularDatabases{
param([Parameter(ValueFromPipeline,position=0)]$serverName
,[string[]]$name = $null)

try{
    Write-Log "loading Microsoft.AnalysisServices assemblies that we need" Debug
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.AnalysisServices.Core") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.AnalysisServices.Tabular") | Out-Null
}
catch{
    Write-Log "Could not load the needed assemblies... TODO: Figure out and document how to install the needed assemblies. (I would start with the SQL feature pack)" Error -ErrorAction Stop
}

$server = New-Object Microsoft.AnalysisServices.Tabular.Server
$server.Connect($serverName)


$out = $server.Databases| where { $_.name -in $(if ($name -eq $null){$_.name}else{$name})}

Write-Output $out
} Export-ModuleMember -function Get-SSASTabularDatabases