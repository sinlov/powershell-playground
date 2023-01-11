Write-Output "more Validate function use cmd to see: help about_Functions_Advanced_Parameters"

function Test-MrFunction {
   <#
   .SYNOPSIS
     Test-MrFunction

   .DESCRIPTION
     use Test-MrFunction

   .PARAMETER ComputerName
     name of computer alias as -cpname

   .PARAMETER drivetype
     drive type only use 1,2,3,4

   .INPUTS
     String

   .OUTPUTS
     PSCustomObject

   .EXAMPLE
     Test-MrFunction -cpname one,two
   #>
  [CmdletBinding()]
  [OutputType([int])]
  param (
      [Parameter(
        Mandatory=$True,
        HelpMessage="Enter more computer name to query")]
      [ValidateCount(1,3)] # only use 1-3
      [Alias('cpname')]
      [string[]]$ComputerName,
      [ValidateSet(1,2,3,4)] # only let ddrivetype use 1,2,3,4
      [int]$drivetype = 3,
      [Parameter(
        Mandatory=$False,
        HelpMessage="Parameter missing: -logDir as string")]
      # [AllowEmptyString()] # can be empty
      [string]$logDir,
      # [AllowEmptyCollection()] # can be empty arr,
      [System.Security.SecureString] # can let out put by ****
      [Parameter(Mandatory=$true)]
      $password
  )

  PROCESS {

    Write-Verbose -Message "this time set -drivetype $drivetype"
    Write-Verbose -Message "this time set -logDir $logDir"

    foreach ($Computer in $ComputerName) {
      Write-Verbose -Message "Attempting to perform some action on $Computer"
      Write-Host $Computer
    }
    Return
  }

}

Write-Host "see Test-MrFunction use helper"
Write-Host "Get-Command -Name Test-MrFunction -Syntax"

Get-Command -Name Test-MrFunction -Syntax

Test-MrFunction -cpname one,two

Write-Host "use -verbose to see more info"

Test-MrFunction -cpname one,two -verbose

Write-Host "-logDir can use empty"

Test-MrFunction -cpname one,two -verbose -logDir ""