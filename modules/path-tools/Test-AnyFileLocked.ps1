function Test-FileLocked([string]$FilePath) {
  try { [IO.File]::OpenWrite($FilePath).close(); return $false }
  catch { return $true }
}

function Test-AnyFileLocked([string]$DirPath) {
  $files = Get-ChildItem $DirPath -Recurse
  foreach ($file in $files) {
      if (Test-FileLocked (Convert-Path $file.PSPath)) {
          return $true
      }
  }
  return $false
}