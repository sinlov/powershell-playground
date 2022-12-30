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

Write-Output "`nTo define collection Numbers 0-9"
$Numbers = @(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)

Write-Output "`nUse [ -Contains ] definition: Determines if a collection contains a specified value"
$Numbers -Contains 9

Write-Output "`nUse [ -NotContains ] definition: Determines if a collection does not contain a specific value"
$Numbers -NotContains 13

Write-Output "`nThe `"in`" comparison operator was first introduced in PowerShell version 3.0. It's used to determine if a value is `"in`" an array"
Write-Output "`nUse [ -In ] definition: Determines if a specified value is in a collection"
8 -In $Numbers

Write-Output "`nUse [ -NotIn ] definition: Determines if a specified value is in a collection"
15 -NotIn $Numbers

Write-Output "`nUse [ -Replace ] definition: Replaces the specified value"
'SQL Saturday - Baton Rouge' -Replace 'saturday','Sat'

Write-Output "`nThere are also methods like Replace() that can be used to replace things similar to the way the replace operator works"
'SQL Saturday - Baton Rouge'.Replace('Saturday','Sat')

Write-Output "`nBut the -Replace operator is case-insensitive by default, and the Replace() method is case-sensitive"
'SQL Saturday - Baton Rouge'.Replace('saturday','Sat')

Write-Output "`nSpecifying one value replaces that value with nothing. In the following example, I replace `"Shell`" with nothing"
'PowerShell' -replace 'Shell'