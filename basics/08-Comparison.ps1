Write-Output "`nAll of the operators listed in are case-insensitive"
Write-Output "Place a ``c`` in front of the operator to make it case-sensitive"

Write-Output "`nUse [ -eq ] definition: Equal to"
'PowerShell' -eq 'powershell'

Write-Output "`nUse [ -ceq ] definition: Equal to and case-sensitive"
'PowerShell' -ceq 'powershell'

Write-Output "`nUse [ -ne ] definition: Not equal to"
'One' -ne 'two'

Write-Output "`nUse [ -gt ] definition: Greater than"
12 -gt 10

Write-Output "`nUse [ -ge ] definition: Greater than or equal to"
'12' -ge '12'

Write-Output "`nUse [ -lt ] definition: Less than"
'11' -lt '12'

Write-Output "`nUse [ -le ] definition: Less than or equal to"
'23' -le '24'

Write-Output "`nUse [ -Like ] definition: Match using the * wildcard character"
'1234' -like '*34'

Write-Output "`nUse [ -NotLike ] definition: Does not match using the * wildcard character"
'12334' -NotLike '*234'

Write-Output "`nUse [ -Match ] definition: Matches the specified regular expression"
'PowerShell' -match '^*.shell$'

Write-Output "`nUse [ -NotMatch ] definition: Does not match the specified regular expression"
'PowerShell' -NotMatch '^Shell*.'