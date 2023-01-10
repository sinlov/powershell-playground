# import module
Import-Module .\z-ci-basic-tools.psm1

# get helper at module
Get-Help Expand-Path
Get-Help Get-RelativeRootDirectory
Get-Help Invoke-FileDownload

if(Compare-StrIsBlank("")){
  Write-Output "Compare-StrIsBlank check str is blank"
}
else {
  Write-Output "Compare-StrIsBlank check str is not blank"
}

if (Compare-StrIsFloat("1.1")) {
  Write-Output "Compare-StrIsFloat is float"
}

[string]$notFloat = "1.1a"
if (Compare-StrIsFloat($notFloat)) {
  Write-Output "Compare-StrIsFloat is float"
} else {
  Write-Output "Compare-StrIsFloat is not float"
}

# Get-Help Compare-StrIsBlank