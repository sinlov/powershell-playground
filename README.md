# this project for powershell playground

- env for windows

powershell 版本需要大于 5.1，执行如下命令查看版本信息

```ps1
($PSVersionTable.PSVersion).ToString()
```

# ps1 文件不可执行

报错为

```
+ CategoryInfo : SecurityError: (:) []，PSSecurityException
+ FullyQualifiedErrorId : UnauthorizedAccess
```

首次在计算机上启动 Windows PowerShell 时，现用执行策略很可能是 `Restricted（默认设置）`
获取当前策略

```ps1
Get-Executionpolicy
# 获取设置帮助
Get-Help Set-ExecutionPolicy
```

- `Restricted` 策略不允许任何脚本运行
- `RemoteSigned` 允许运行您编写的未签名脚本和来自其他用户的签名脚本

```ps1
# 改变策略，运行按需运行
Set-ExecutionPolicy Bypass -Scope Process
# 改变策略，允许执行脚本
set-executionpolicy Remotesigned
# 改变策略，不允许未签名运行
set-executionpolicy Restricted
```

## 下载内置命令的手册

```ps1
Update-Help Microsoft.PowerShell.*
# 也可以获取到非官方帮助
```

> 注意要在管理员权限下运行

## 常用 powershell 技巧

### 获取命令帮助

```ps1
> help Get-EventLog
> Get-Help [cmd]
> Get-Help -Full [cmd]
# 获取命令位置
> Get-Command [cmd]
# 获取对象的属性和方法
> Get-Service | Get-Member [method]
```

### 别名命令

在powershell中，有一些命令有和shell命令一样的别名，但是功能和输出有所不同

- `ls` 和 `find` 的替代品是 `Get-ChildItem` 不过你也可以直接用ls来调用
- `pwd` 的替代品是 `Get-Location` ， 不过用 `pwd` 也可以调用，因为微软内置了这个别名
- `cd` 的替代品是 `Set-Location` ，也可以用 `cd` 调用
- `which` 的替代品是 `Get-Command`
- `cp` 的替代品是 `Copy-Item` ，也可以用 cp 调用
- `rm` , `rmdir` , 和 `del` 都是 `Remove-Item` 的别名
- `mkdir` 是 `New-Item` 的别名，也可以跟 `touch` 一样新建文件
- `cat` ，`tail` ，`head` 可以用 `Get-Content` 配合命令行参数实现 用 cat 就可以加 tab 找参数调用

### git_tools

这个目录下有 git alias 别名增强，使用方法是

```bash
# 记事本打开配置
notepad $profile
# 有 vscode 则使用
code $profile
```

把脚本内容复制进去，然后保存，重启 powershell 即可