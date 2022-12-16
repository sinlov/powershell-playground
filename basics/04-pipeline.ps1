Write-Output "`nsame as shell [ grep ] to get some raws`
powershell use [ Where-Object ] to get raws`
"

Write-Output "`n=> Get stopped services`
Get-Service | Where-Object {`$_.Status -eq `"Stopped`"}`
"
Get-Service | Where-Object {$_.Status -eq "Stopped"}

Write-Output "`n=> Get processes based on working`
Get-Process | Where-Object {`$_.WorkingSet -GT 250MB}`
"
Get-Process | Where-Object {$_.WorkingSet -GT 250MB}

Write-Output "`n=> processes based on process name`
Get-Process | Where-Object {`$_.ProcessName -Match `"^p.*`"}`
"
Get-Process | Where-Object {$_.ProcessName -Match "^p.*"}

Write-Output "`n=> Use the comparison statement format`
Get-Process | Where-Object -Property Handles -GE -Value 1000`
"
Get-Process | Where-Object -Property Handles -GE -Value 1000


Write-Output "`nsome as shell use [ awk ] to get some columns`
powershell use [ Select-Object ] to get raws`
"
Write-Output "`n=> list this dir files as name`
ls | Select-Object -Property Name`
"
ls | Select-Object -Property Name