## powershell 换行符

在 powershell 中，换行符是 ``n` 不是常见的 `\n`

## powershell 别名

- [https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-alias?view=powershell-5.1](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-alias?view=powershell-5.1)

```ps1
> Get-Alias
# 获取 gp sp 开头的，排除 ps 结尾的 别名
> Get-Alias -Name gp*, sp* -Exclude *ps
```

## Powershell 中的管道

Powershell 中的管道和 bash 有所不同，传递的是对象而不是字符串

### 命令输出取行

在 shell 中我们通常用 `grep` 实现，在 powershell 中可以用 `Where-Object` 实现

- [https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/where-object?view=powershell-5.1](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/where-object?view=powershell-5.1)

```ps1
# Get stopped services
> Get-Service | Where-Object {$_.Status -eq "Stopped"}
> Get-Service | where Status -eq "Stopped"

# Get processes based on working
> Get-Process | Where-Object {$_.WorkingSet -GT 250MB}
> Get-Process | Where-Object WorkingSet -GT (250MB)

# Get processes based on process name
> Get-Process | Where-Object {$_.ProcessName -Match "^p.*"}
> Get-Process | Where-Object ProcessName -Match "^p.*"
> Get-Process | where Handles -GE 1000

#  Use the comparison statement format
> Get-Process | Where-Object -Property Handles -GE -Value 1000
```

### 命令输出取列

在shell中通常是用 `awk` 来实现的，powershell中是用 `Select-Object -Property` 实现

> powershell 中管道传递的是对象，其实这个并不是字符串取列而是取了对象或对象的属性

- [https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/select-object?view=powershell-5.1](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/select-object?view=powershell-5.1)

```ps1
> ls | Select-Object -Property Name
Name
----
powershell-playground
```

## 查看、添加用户或系统环境变量

- 临时设置环境变量

```ps1
# 临时设置环境变量
> $env:RUN_MODE="dev"
# 获取临时环境变量
> $env:RUN_MODE
# 使用临时环境变量
echo "show env RUN_MODE: ${env:RUN_MODE}"
```

- 永久设置环境变量

```ps1
> [Environment]::GetEnvironmentvariable("Path", "User")
> [Environment]::SetEnvironmentVariable("Path", "F:\KK\", "User")

#查看/添加系统环境变量
> [Environment]::GetEnvironmentvariable("Path", "Machine")
> [Environment]::SetEnvironmentVariable( "Path", $env:Path + ";F:\KK\", [System.EnvironmentVariableTarget]::Machine )
```