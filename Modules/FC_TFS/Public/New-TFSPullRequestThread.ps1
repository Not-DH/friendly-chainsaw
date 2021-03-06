﻿function New-TFSPullRequestThread{
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
[CmdletBinding(SupportsShouldProcess=$true)] 
param([Parameter(ValueFromPipeline)] $pipelineInput
,[string] $Message
)

$repositoryID = $pipelineInput.repository.id
$repositoryName = $pipelineInput.repository.Name
$pullRequestID = $pipelineInput.PullRequests.PullRequestID
$projectID = $pipelineInput.repository.project.id


if ([String]::IsNullOrEmpty($repositoryID)){
    Write-Log "Please pass a repositoryID" Error
    return
}
if ([String]::IsNullOrEmpty($pullRequestID)){
    Write-Log "Please pass a pullRequestID" Error
    return
}
if ([String]::IsNullOrEmpty($Message)){
    Write-Log "Please pass a Message" Error
    return
}
$outputObj = $pipelineInput


$requestBody = ''
$requestBody = @"
{
  "comments": [
    {
      "parentCommentId": 0,
      "content": "$Message",
      "commentType": 1
    }
  ],
  "properties": {
    "Microsoft.TeamFoundation.Discussion.SupportsMarkdown": {
      "type": "System.Int32",
      "value": 1
    }
  },
  "status": 1
}
"@
$BaseTFSURL = Get-TFSRestURL
$action = "/git/repositories/$($repositoryID)/pullrequests/$($pullRequestID)/threads?api-version=$($script:apiVersion)" 
$fullURL = $BaseTFSURL + $action
Write-Log "URL we are calling: $fullURL" Debug
$response = (Invoke-RestMethod -UseDefaultCredentials -uri $fullURL -Method POST -Body $requestBody -ContentType "application/json").value

$outputObj.PullRequests | Add-Member -Type NoteProperty -Name Thread -Value $response

Write-Output $outputObj
} Export-ModuleMember -Function New-TFSPullRequestThread