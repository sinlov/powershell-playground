Write-Output "`nUse @() to define array"
$ALGORITHMS = @("MD5", "SHA1", "SHA256")

Write-Output "`nUse pipeline and ForEach-Object"
$ALGORITHMS | ForEach-Object {
  Write-Output $_ #for each
}

Write-Output "`nOr use as this"
'MD5', 'SHA1', 'SHA256' |
  ForEach-Object { Write-Output $_}

Write-Output "`nMost of time, we must store all of the items in memory before iterating through them, which could be difficult if you don't know how many items you're working with"

foreach ($algo in $ALGORITHMS) {
  <# $algo is the current item #>
  Write-Output "foreach now: $algo"
}


Write-Output "`nFor loop iterates while a specified condition is true"

for ($i = 1; $i -lt 5; $i++) {
  Write-Output "Sleeping for $i seconds"
  Start-Sleep -Seconds $i
}

Write-Output "`nThere are two different do loops in PowerShell.`nDo Until runs while the specified condition is false"
$number = Get-Random -Minimum 1 -Maximum 10
do {
  $guess = Read-Host -Prompt "What's your guess between 1-10 ?"
  if ($guess -lt $number) {
    Write-Output 'Too low!'
  }
  elseif ($guess -gt $number) {
    Write-Output 'Too high!'
  }
}
until ($guess -eq $number)
Write-Output "now guess number is $guess"

Write-Output "`nDo While is just the opposite. It runs as long as the specified condition evaluates to true."

do {
  $guess = Read-Host -Prompt "What's your guess between 1-10 ?"
  if ($guess -lt $number) {
    Write-Output 'Too low!'
  }
  elseif ($guess -gt $number) {
    Write-Output 'Too high!'
  }
}
while ($guess -ne $number)
Write-Output "now guess number is $guess"

Write-Output "`nThat a While loop runs as long as the specified condition is true"

$date = Get-Date -Date 'November 22'
while ($date.DayOfWeek -ne 'Thursday') {
  $date = $date.AddDays(1)
}
Write-Output $date

Write-Output "`nBreak is designed to break out of a loop. It's also commonly used with the switch statement."
for ($i = 1; $i -lt 5; $i++) {
  Write-Output "Sleeping for $i seconds"
  Start-Sleep -Seconds $i
  break
}

Write-Output "`nContinue is designed to skip to the next iteration of a loop."
while ($i -lt 5) {
  $i += 1
  if ($i -eq 3) {
    continue
  }
  Write-Output $i
}

Write-Output "`nReturn is designed to exit out of the existing scope."
$numbers = 1..10
foreach ($n in $numbers) {
  if ($n -ge 4) {
    Return $n
  }
}
