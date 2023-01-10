Write-Output "`nTurning a function in PowerShell into an advanced function is really simple. One of the differences between a function and an advanced function is that advanced functions have a number of common parameters that are added to the function automatically. These common parameters include parameters such as Verbose and Debug."

function Test-MrParameter {

  param (
      $ComputerName
  )

  Write-Output $ComputerName

}

Get-Command -Name Test-MrParameter -Syntax

Write-Output "`nAdd CmdletBinding to turn the function into an advanced function"
function Test-MrCmdletBinding {

  [CmdletBinding()] #<<-- This turns a regular function into an advanced function
  param (
      $ComputerName
  )

  Write-Output $ComputerName

}

Get-Command -Name Test-MrCmdletBinding -Syntax

Write-Output "`nDrilling down into the parameters with Get-Command shows the actual parameter names including the common ones."

(Get-Command -Name Test-MrCmdletBinding).Parameters.Keys

Write-Output "`nSupportsShouldProcess adds WhatIf and Confirm parameters. These are only needed for commands that make changes."

function Test-MrSupportsShouldProcess {

  [CmdletBinding(SupportsShouldProcess)]
  param (
      $ComputerName
  )

  Write-Output $ComputerName

}

Write-Output "`nNotice that there are now WhatIf and Confirm parameters."

Get-Command -Name Test-MrSupportsShouldProcess -Syntax

Write-Output "`nOnce again, you can also use Get-Command to return a list of the actual parameter names including the common ones along with WhatIf and Confirm."

(Get-Command -Name Test-MrSupportsShouldProcess).Parameters.Keys

Write-Output "`nValidate input early on"
Write-Output "Always type the variables that are being used for your parameters (specify a datatype)."

function Test-MrParameterValidation {

  [CmdletBinding()]
  param (
      [Parameter(Mandatory)]
      [string]$ComputerName
  )

  Write-Output $ComputerName

}

Write-Output "`nIn the previous example, I've specified String as the datatype for the ComputerName parameter. This causes it to allow only a single computer name to be specified. If more than one computer name is specified via a comma-separated list, an error is generated."
Write-Output "If run as: Test-MrParameterValidation -ComputerName Server01, Server02"
Write-Output "The problem with the current definition is that it's valid to omit the value of the ComputerName parameter, but a value is required for the function to complete successfully. This is where the Mandatory parameter attribute comes in handy."


Write-Output "`nbetter option is to use Write-Verbose instead of inline comments."

function Test-MrVerboseOutput {

  [CmdletBinding()]
  param (
      [ValidateNotNullOrEmpty()]
      [string[]]$ComputerName = $env:COMPUTERNAME
  )

  foreach ($Computer in $ComputerName) {
      Write-Verbose -Message "Attempting to perform some action on $Computer"
      Write-Output $Computer
  }

}

Test-MrVerboseOutput -ComputerName Server01, Server02

Write-Output "`nWhen it's called with the Verbose parameter, the verbose output will be displayed."

Test-MrVerboseOutput -ComputerName Server01, Server02 -Verbose

Write-Output "`nWhen you want your function to accept pipeline input, some additional coding is necessary. As mentioned earlier in this book, commands can accept pipeline input by value (by type) or by property name. You can write your functions just like the native commands so that they accept either one or both of these types of input."
Write-Output "To accept pipeline input by value, specified the ValueFromPipeline parameter attribute for that particular parameter."

function Test-MrPipelineInput {

  [CmdletBinding()]
  param (
      [Parameter(Mandatory,
                 ValueFromPipeline)]
      [string[]]$ComputerName
  )

  PROCESS {
      Write-Output $ComputerName
  }

}