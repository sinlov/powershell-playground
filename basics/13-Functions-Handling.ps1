Write-Output "`nAlthough the function shown in the previous example uses error handling, it also generates an unhandled exception because the command doesn't generate a terminating error."
Write-Output "Specify the ErrorAction parameter with Stop as the value to turn a non-terminating error into a terminating one."

function Test-MrErrorHandling {

  [CmdletBinding()]
  param (
      [Parameter(Mandatory,
                 ValueFromPipeline,
                 ValueFromPipelineByPropertyName)]
      [string[]]$ComputerName
  )

  PROCESS {
      foreach ($Computer in $ComputerName) {
          try {
              Test-WSMan -ComputerName $Computer -ErrorAction Stop
          }
          catch {
              Write-Warning -Message "Unable to connect to Computer: $Computer"
          }
      }
  }

}

Test-MrErrorHandling -ComputerName one,two