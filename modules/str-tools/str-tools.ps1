Function Compare-StrIsBlank ([string]$InputObject) {
  if (($InputObject -eq "") -or ($InputObject -eq $Null)) {
    Return $True
  } else {
    Return $False
  }
}

Function Compare-StrIsInteger ([string]$InputObject) {
  if ($InputObject -match "^\d+$" ) {
    Return $True
  } else {
    Return $False
  }
}

Function Compare-StrIsFloat ([string]$InputObject) {
  if ($InputObject -match "^\d+\.\d+$") {
    Return $True
  } else {
    Return $False
  }
}

Function Compare-IsIPAddr ([string]$InputObject) {
  if ($InputObject -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$") {
    Foreach ($Local:str in $InputObject.split(".")) {
      if (([int16]$str -gt 255) -or (($str -match "^0") -and ($str -ne "0"))) {
        #IP任意一段大于255或(以0开头但不等于0)则无效
        Return $False
      }
    }
    if ( [int16]$InputObject.split(".")[0] -eq 0 ) {
      #IP首位等于0则无效
      Return $False
    }
      Return $True
  } else {
    #IP不符合四段3位数值格式则无效
    Return $False
  }
}


Function Compare-IsNetmask([string]$InputObject) {
  if ($InputObject -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$") {
    #将子网掩码转换为二进制字符串，不足8位的在左侧填0
    $Mask = -join ($InputObject.Split('.') | ForEach-Object {[System.Convert]::ToString($_,2).PadLeft(8,'0')})
    #判断是否连续1开头，连续0结尾
    if (($Mask -match '^1+0+$') -and ($Mask.Length -le 32)) {
      Return $True
    } else {
      Return $False
    }
  } else {
    Return $False #不符合IP的四段3位数字格式
  }
}