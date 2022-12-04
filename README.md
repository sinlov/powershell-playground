# this project for powershell playground

- env for windows

powershell 版本需要大于 5.1，执行如下命令查看版本信息

```ps1
$PSVersionTable
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