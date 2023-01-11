Function Get-ScriptSelfName () {
  <#
  .Notes
    if want script root, please use $PSScriptRoot
  #>
  Return (Get-ChildItem "$PSCommandPath").Name
}

Function Get-ScriptFullPath () {
  <#
    .Notes
      this will return as $PSCommandPath
  #>
  Return (Join-Path $PSScriptRoot (Get-ScriptSelfName))
  # powershell 3.0 remove $MyInvocation
  # Return (Split-Path -Parent $MyInvocation.MyCommand.Definition)
}