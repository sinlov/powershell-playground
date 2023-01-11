Function Get-ScriptSelfName () {
  <#
  .Notes
    if want script root, please use $PSScriptRoot
  #>
  Return (Get-ChildItem "$PSCommandPath").Name
}

# import module
Import-Module (Join-Path $PSScriptRoot "z-ci-basic-tools.psm1")

# get helper at module
Get-Help Expand-Path
Get-Help Get-RelativeRootDirectory
Get-Help Invoke-FileDownload

if(Compare-StrIsBlank("")){
  Write-Host "Compare-StrIsBlank check str is blank"
}
else {
  Write-Host "Compare-StrIsBlank check str is not blank"
}

if (Compare-StrIsFloat("1.1")) {
  Write-Host "Compare-StrIsFloat is float"
}

[string]$notFloat = "1.1a"
if (Compare-StrIsFloat($notFloat)) {
  Write-Host "Compare-StrIsFloat is float"
} else {
  Write-Host "Compare-StrIsFloat is not float"
}

# Get-Help Compare-StrIsBlank