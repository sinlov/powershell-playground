<#
  .SYNOPSIS
   foo-kit

  .DESCRIPTION
   foo-kit.ps1

  .PARAMETER help
  use -help show Get-Help

  .PARAMETER env
  use -env to show env


  .PARAMETER mainExec
  do as mainExec path

  .PARAMETER ProjectBuildRoot
  set build unity root, if not settings will use $PSScriptRoot

 .INPUTS
  String

 .OUTPUTS
   PSCustomObject

 .EXAMPLE
  foo-kit
#>
[CmdletBinding()]
param (
  [switch]$help,
  [switch]$env,

  [Parameter(
    Mandatory = $False,
    HelpMessage = "Parameter missing: -MainExec as string")]
  [string]$mainExec,

  [Parameter(
    Mandatory = $False,
    HelpMessage = "Parameter missing: -ProjectBuildRoot as string"
  )]
  [string]$ProjectBuildRoot
)


# import module
Import-Module (Join-Path $PSScriptRoot "z-make-file.psm1")

Function Get-ScriptSelfName() {
  <#
  .Notes
    if want script root, please use $PSScriptRoot
  #>
  Return (Get-ChildItem "$PSCommandPath").Name
}

if (Compare-StrIsBlank($ProjectBuildRoot)) {
  $ProjectBuildRoot = $PSScriptRoot
}

<#
  .Notes
    define var for build
#>

$DefaultMainExec =
"git"

$mainExec =
ConvertFrom-ParameterStr $mainExec $DefaultMainExec

if ($env) {
  Write-Host "===== Show env begin ====="
  Write-Debug "this message only in debug mode, and can break this script"

  Write-Verbose -Message "This script tools root path: ${PSScriptRoot}"
  Write-Verbose -Message "This script name is        : $(Get-ScriptSelfName)"

  Write-Host "Build as exec args"
  Write-Host ""
  Write-Host "ProjectBuildRoot              $ProjectBuildRoot"
  Write-Host ""
  Write-Host "===== Show env end ====="
  Return
}

if ($help) {
  Get-Help $PSCommandPath
  Return
}


if (Test-CommandExist -CommandName $mainExec -Exit) {
}

$runRes = Start-Exec -workingDir $ProjectBuildRoot `
  -exec ${mainExec} `
  -arguments "--help"
# -notShowOut $True `
Write-Output "runRes code: ${runRes}"