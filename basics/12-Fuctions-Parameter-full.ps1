Write-Output "more Validate function use cmd to see: help about_Functions_Advanced_Parameters"

function Test-MrFunction {

  [CmdletBinding()]
  param (
      [Parameter(
        Mandatory=$True,
        HelpMessage="Enter a computer name to query")]
      [Alias('cpname')]
      [string[]]$ComputerName,
      [ValidateSet(1,2,3,4)] # only let ddrivetype use 1,2,3,4
      [int]$drivetype = 3
  )

  PROCESS {

    Write-Verbose -Message "this time set -drivetype $drivetype"

    foreach ($Computer in $ComputerName) {
      Write-Verbose -Message "Attempting to perform some action on $Computer"
      Write-Output $Computer
    }
  }

}

Write-Output "see Test-MrFunction use helper"
Write-Output "Get-Command -Name Test-MrFunction -Syntax"

Get-Command -Name Test-MrFunction -Syntax

Test-MrFunction -cpname one,two

Write-Output "use -verbose to see more info"

Test-MrFunction -cpname one,two -verbose