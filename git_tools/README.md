
## git tools

```bash
# 记事本打开配置
notepad $profile
# 有 vscode 则使用
code $profile
```

把脚本内容复制进去，然后保存，重启 powershell 即可

### git alias

设置了非常多常用 git 操作 alias，使用最多的为

- 状态查看 gst gbv gsl gcrurl
- 比较差别 gds gdca gdup gdw
- 提交整理 gaa gcdfx
- 日志查看 glr gll glos gloo
- 版本维护 gcmpt gdct
- 回滚撤销 grhh grshb

详细见 [git_alias.psm1](git_alias.psm1)