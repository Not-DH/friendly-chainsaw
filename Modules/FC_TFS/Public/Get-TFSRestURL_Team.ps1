﻿function Get-TFSRestURL_Team{
<#
    .Synopsis
      Please give your script a brief Synopsis,
    .DESCRIPTION
      A slightly longer description,
    .PARAMETER logLevel
        explain your parameters here. Create a new .PARAMETER line for each parameter,
       
    .EXAMPLE
        THis example runs the script with a change to the logLevel parameter.

        .Template.ps1 -logLevel Debug

    .INPUTS
       What sort of pipeline inputdoes this expect?
    .OUTPUTS
       What sort of pipeline output does this output?
    .LINK
       www.google.com
    #>
param([string] $teamName)
if([string]::IsNullOrEmpty($teamname)){
    Write-Log "invalid teamName" error -ErrorAction Stop
}
Write-Output "$script:TFSbaseURL/$script:TFSCollection/$script:TFSTeamProject/$teamName/_apis"

} Export-ModuleMember -Function Get-TFSRestURL_Team