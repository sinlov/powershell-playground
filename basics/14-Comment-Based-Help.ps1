Write-Output "`nIt's considered to be a best practice to add comment based help to your functions so the people you're sharing them with will know how to use them."


function Get-MrAutoStoppedService {

  <#
  .SYNOPSIS
      Returns a list of services that are set to start automatically, are not
      currently running, excluding the services that are set to delayed start.

  .DESCRIPTION
      Get-MrAutoStoppedService is a function that returns a list of services from
      the specified remote computer(s) that are set to start automatically, are not
      currently running, and it excludes the services that are set to start automatically
      with a delayed startup.

  .PARAMETER ComputerName
      The remote computer(s) to check the status of the services on.

  .PARAMETER Credential
      Specifies a user account that has permission to perform this action. The default
      is the current user.

  .EXAMPLE
       Get-MrAutoStoppedService -ComputerName 'Server1', 'Server2'

  .EXAMPLE
       'Server1', 'Server2' | Get-MrAutoStoppedService

  .EXAMPLE
       Get-MrAutoStoppedService -ComputerName 'Server1' -Credential (Get-Credential)

  .INPUTS
      String

  .OUTPUTS
      PSCustomObject

  .NOTES
      Author:  Mike F Robbins
      Website: http://mikefrobbins.com
      Twitter: @mikefrobbins
  #>

      [CmdletBinding()]
      [OutputType([Boolean])]
      param (

      )

      #Function Body

}

Get-Help Get-MrAutoStoppedService