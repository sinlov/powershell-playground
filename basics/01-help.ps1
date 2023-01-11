# see help
help Get-EventLog

# let debug

function Get-Test()
{
    Write-Debug "Try to calculate."
    "3.1415926"
    Write-Debug "Done."
}

# Debugging information will only be output in debug mode
$value = Get-Test
Write-Host "no debug ${value}"

# If you want to debug the function by displaying debug information, you can turn on debug mode
$DebugPreference="Continue"
$value = Get-Test
Write-Host "open debug ${value}"

# If debug mode is turned off, the debug information will not be output.
$DebugPreference="SilentlyContinue"
$value = Get-Test
Write-Host "close debug ${value}"