<#
  .SYNOPSIS
   portable-exec

  .DESCRIPTION
   portable-exec

  .PARAMETER help
  use -help show Get-Help

  .PARAMETER env
  use -env to show env

  .PARAMETER path
  path of biz

  .PARAMETER ComputerName
  args can like cp-one,cp-two and only count 1-3

 .PARAMETER drivetype
  drive type only use 1,2,3,4

 .INPUTS
  String

 .OUTPUTS
   PSCustomObject

 .EXAMPLE
  portable-exec -cpname one,two
#>
 [CmdletBinding()]
 param (
   [switch]$help,

   [switch]$env,

   [AllowEmptyString()]
   [Parameter(
    Mandatory=$False,
    HelpMessage="Parameter missing: -path as string")]
   [string]$path,

   [Parameter(
     Mandatory=$False,
     HelpMessage="Enter more computer name to query")]
   [ValidateCount(1,3)] # only count as 1-3
   [Alias('cpname')]
   [string[]]$ComputerName,

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

Function Compare-StrIsBlank ([string]$InputObject) {
  if (($InputObject -eq "") -or ($InputObject -eq $Null)) {
    Return $True
  } else {
    Return $False
  }
}

# import module
# Import-Module (Join-Path $PSScriptRoot "xxx.psm1")

if (Compare-StrIsBlank($path)){
  $path = $PSScriptRoot
}

if ($help) {
  Get-Help $PSCommandPath
  Return
}

if ($env) {
  Write-Debug "this message only in debug mode, and can break this script"

  Write-Verbose -Message "This script tools root path: ${PSScriptRoot}"

  Write-Host "Build as exec args"
  Write-Host "path         $path"
  Return
}
