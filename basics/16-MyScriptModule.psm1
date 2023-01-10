function Get-MrPSVersion {
  ($PSVersionTable.PSVersion).ToString()
}

function Get-MrPSCLRVersion {
  ($PSVersionTable.CLRVersion).ToString()
}

function Get-MrComputerName {
  $env:COMPUTERNAME
}

Export-ModuleMember -Function Get-MrComputerName,Get-MrPSVersion