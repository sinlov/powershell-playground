Write-Output "`nYou could manually import the file with the Import-Module cmdlet."

Import-Module .\15-MyScriptModule.psm1

Write-Output "`nTo take advantage of module autoloading, a script module needs to be saved in a folder with the same base name as the .PSM1 file and in a location specified in `$env:PSModulePath."
Write-Output "This makes them easier to read: `$env:PSModulePath -split ';'"

Write-Output "`nUse load module"
Get-MrComputerName


Write-Output "`nModule Manifests"
Write-Output "The file extension for a module manifest file is .PSD1"
Write-Output "New-ModuleManifest is used to create a module manifest."
Write-Output "The version of a module without a manifest is 0.0. This is a dead giveaway that the module doesn't have a manifest."
Write-Output "If any of this information is missed during the initial creation of the module manifest, it can be added or updated later using Update-ModuleManifest."