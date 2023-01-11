Write-Host "`nIn fact, the difference between the two is that Write-Host only outputs the string to the screen, while Write-Output can pass the object output."

Function WriteTest($amount, $rate=0.8)
{
    $amount * $rate
}
Function WriteOutputTest($amount, $rate=0.8)
{
    Write-Output $amount * $rate
}

WriteTest 100

WriteOutputTest 100
$a = (WriteOutputTest 50)
Write-Host "a = $a"

Function WriteHostputTest($amount, $rate=0.8)
{
    Write-Host $amount * $rate
}


$b = (WriteHostputTest 50)
Write-Host "b = $b"