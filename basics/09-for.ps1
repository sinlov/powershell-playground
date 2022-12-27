Write-Output "`nUse @() to define array"
$ALGORITHMS = @("MD5", "SHA1", "SHA256")

Write-Output "`nUse pipeline and ForEach-Object"
$ALGORITHMS | ForEach-Object {
  Write-Output $_ #for each
}