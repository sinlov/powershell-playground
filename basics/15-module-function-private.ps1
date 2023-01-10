Write-Output "`nYou may have helper functions that you may want to be private and only accessible by other functions within the module."
Write-Output "your only option is to use the Export-ModuleMember cmdlet"

Write-Output "It's not necessary to use both Export-ModuleMember in the .PSM1 file and the FunctionsToExport section of the module manifest."
Write-Output "One or the other is sufficient."

Import-Module .\15-MyScriptModule.psm1

Write-Output "`nUse module function"

Get-MrComputerName
Get-MrPSVersion