## powershell 换行符

在 powershell 中，换行符是 ``n` 不是常见的 `\n`

## Powershell 中的管道

Powershell 中的管道和 bash 有所不同，传递的是对象而不是字符串

[https://learn.microsoft.com/zh-cn/powershell/scripting/learn/ps101/04-pipelines?view=powershell-5.1#the-pipeline](https://learn.microsoft.com/zh-cn/powershell/scripting/learn/ps101/04-pipelines?view=powershell-5.1#the-pipeline)

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
# 查看用户环境变量 等效 echo "${env:Path}"
> [Environment]::GetEnvironmentvariable("Path", "User")
> [Environment]::SetEnvironmentVariable("Path", "c:\opt\bin", "User")

# 查看/添加系统环境变量
> [Environment]::GetEnvironmentvariable("Path", "Machine")
> [Environment]::SetEnvironmentVariable( "Path", $env:Path + ";C:\opt\bin", [System.EnvironmentVariableTarget]::Machine )
```

## Cmdlet 命名惯例

> cmdlet 全称为 `command-let` 是一个原生命令行工具。
> 函数和 Cmdlet 类似，但不是以 .Net 语言编写，而是使用 powershell 自己的脚本语言编写
> 工作流是嵌入 PowerShell 的工作流系统的一类特殊函数
> 应用程序可以是任意外部可执行程序，包括各种命令行程序，命令脚本

- 规则一，应该使用标准的动词开始，比如: Get Set New Pause ， 运行 `Get-Verb` 查看允许的动词表，后跟一个 `-` 加单数名词
- 不是所有的都是 `动词-名词`，其实可以使用 `动词-动词` 作为组合

## powershell 别名

- [https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-alias?view=powershell-5.1](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-alias?view=powershell-5.1)

```ps1
> Get-Alias
# 获取 gp sp 开头的，排除 ps 结尾的 别名
> Get-Alias -Name gp*, sp* -Exclude *ps
```

可以通过 `New-Alias` 创建自定义别名

使用 `Export-Alias` 导出别名列表

```ps1
> Export-Alias -Path "alias.csv"
```

- [https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/export-alias?view=powershell-5.1](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/export-alias?view=powershell-5.1)

## 参数别名

Powershell 不强制输入完整的参数名称
简化规则是 `必须输入足够的字母，让 PowerShell 可以识别不同参数`

比如 `-Cn` 可以等效 `-ComputerName`

```ps1
> Get-EventLog -LogName Security -ComputerName SERVER2 -Newest 10
> Get-EventLog -LogName Security -Cn SERVER2 -Newest 10
```

## 图形化参数

使用 `Show-Command` 可以直接列出图形化的参数

> 注意： Show-Command 不能用在没有图形化的服务器上

## 比较运算符

- [https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/05-formatting-aliases-providers-comparison?view=powershell-5.1#comparison-operators](https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/05-formatting-aliases-providers-comparison?view=powershell-5.1#comparison-operators)

## 运行外部命令技巧

因为无法保证外部命令在 PowerShell 中的运行，所以当一个外部命令有很多参数，或者运行有冲突，可以这么做

```ps1
$exe = "C:\opt\bin\vmd.exe"
$host = "server"
$user = "foo"
$password = "pasword"
$machine = "bar"
$location = "somelocation"

& $exe -h $host -u $user -p $password -s "name:${machine}" -r "$location"
```