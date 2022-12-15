Write-Output "`n=> commod shell: [ ls ] "
Get-ChildItem
Write-Output "`n-> this same as: [ Get-ChildItem ]"
Get-ChildItem


Write-Output "`n=> commod shell: [ pwd ] "
Get-Location
Write-Output "`n-> this same as: [ Get-Location ]"
Get-Location

Write-Output "`n=> commod shell: [ cd ] "
Set-Location .
Write-Output "`n-> this same as: [ Set-Location ]"
Set-Location .