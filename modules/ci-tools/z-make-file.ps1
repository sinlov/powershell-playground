<#
  .SYNOPSIS
   z-make-file

  .DESCRIPTION
   z-make-file.ps1

  .PARAMETER help
  use -help show Get-Help

  .PARAMETER env
  use -env to show env

  .PARAMETER path
  path of biz, if not set will use default path

  .PARAMETER mainExec
  do as mainExec path

  .PARAMETER buildTarget
  buildTarget must set as ["Android", iOS]

  .PARAMETER computerName
  args can like cp-one,cp-two and only count 1-3

 .PARAMETER drivetype
  drive type only use 1,2,3,4

 .INPUTS
  String

 .OUTPUTS
   PSCustomObject

 .EXAMPLE
  z-make-file -cpname one,two
#>
[CmdletBinding()]
  param (
    [switch]$help,
    [switch]$env,
    [Parameter(
      Mandatory=$False,
      HelpMessage="Parameter missing: -path as string")]
    [string]$path,
    [Parameter(
      Mandatory=$False,
      HelpMessage="Parameter missing: -MainExec as string")]
    [string]$mainExec,
    [Parameter(
      Mandatory=$False,
      HelpMessage="Parameter missing: -BuildTarget must set"
    )]
    [ValidateSet(
      "Android", "iOS",
      IgnoreCase=$False
    )]
    [string]$buildTarget,
    [Parameter(
      Mandatory=$False,
      HelpMessage="Enter more computer name to query")]
    [ValidateCount(1,3)] # only count as 1-3
    [Alias('cpname')]
    [string[]]$computerName,
    [ValidateSet(1,2,3,4)] # only let ddrivetype use 1,2,3,4
    [int]$drivetype = 3
  )

Function Get-ScriptSelfName () {
  <#
  .Notes
    if want script root, please use $PSScriptRoot
  #>
  Return (Get-ChildItem "$PSCommandPath").Name
}

Function Get-DateTagFull {
  Return (Get-Date).ToString('yyyy-MM-dd-HH-mm-ss')
}

# import module
Import-Module (Join-Path $PSScriptRoot "z-ci-basic-tools.psm1")

function Find-BuildMarkTag {
  "$(Get-DateTagFull)-$(Find-GitBranchInfo)-$(Find-GetCommitIdShort)"
}

$buildGitBranchInfo = Find-GitBranchInfo
$buildGitCommitId = Find-GitCommitId
$buildGitCommitIdShort = Find-GetCommitIdShort
$buildMarkTag = "$(Find-BuildMarkTag)"

<#
  .Notes
    define var for build
#>

$DefaultMainExec =
  "cmake"

$mainExec =
   ConvertFrom-ParameterStr $mainExec $DefaultMainExec

if (Compare-StrIsBlank($path)){
  $path = $PSScriptRoot
}
if (Test-PathNotExist $path $True "arg -path set"){
  Return
}

if ($env) {
  Write-Host "===== Show env begin ====="
  Write-Debug "this message only in debug mode, and can break this script"

  Write-Verbose -Message "This script tools root path: ${PSScriptRoot}"

  Write-Host "Build as exec args"
  Write-Host ""
  Write-Host "DefaultMainExec        $DefaultMainExec"
  Write-Host ""
  Write-Host "path                   $path"
  Write-Host "mainExec               $mainExec"
  Write-Host ""
  Write-Host "Build mark"
  Write-Host " this build only support windows at powershell"
  Write-Host "buildGitBranchInfo         ${buildGitBranchInfo}"
  Write-Host "buildGitCommitId           ${buildGitCommitId}"
  Write-Host "buildGitCommitIdShort      ${buildGitCommitIdShort}"
  Write-Host "buildMarkTag               ${buildMarkTag}"
  Write-Host ""
  Write-Host "===== Show env end ====="
  Return
}

if ($help) {
  Get-Help $PSCommandPath
  Return
}

$runRes = Start-Exec -workingDir $PSScriptRoot `
-exec ${mainExec} `
-arguments "--help"
# -notShowOut $True `