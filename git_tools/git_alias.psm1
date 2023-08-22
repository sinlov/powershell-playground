# alias gst => git status
Function GitStatusFun {git status}
Set-Alias -Name gst -Value GitStatusFun
# alias gpl => git pull
Function GitPullFun {git pull}
Set-Alias -Name gpl -Value GitPullFun
# alias gaa => git add --all
Function GitAddAllFun {git add --all}
Set-Alias -Name gaa -Value GitAddAllFun
# alias ga => git add
Function GitAddSomeFun {git add}
Set-Alias -Name ga -Value GitAddSomeFun
# alias gsl
Function GitStatuslogPrettyFun {git status ; git --no-pager log --pretty=reference -1}
Set-Alias -Name gsl -Value GitStatuslogPrettyFun
# alias glr
Function GitLogPrettyFun {git --no-pager log --pretty=reference -1}
Set-Alias -Name glr -Value GitLogPrettyFun
# alias gll
Function GitLogDecorateFun {git --no-pager log --decorate -1}
Set-Alias -Name gll -Value GitLogDecorateFun
# alias glos
Function GitLogDecorateOnlineFun {git --no-pager log --oneline --decorate -1}
Set-Alias -Name glos -Value GitLogDecorateOnlineFun
# alias gloo
Function GitLogPrettyOnlineFun {git --no-pager log --pretty=oneline -1}
Set-Alias -Name gloo -Value GitLogPrettyOnlineFun
# alias gb
Function GitBranchFun {git branch}
Set-Alias -Name gb -Value GitBranchFun
# alias gba
Function GitBranchAllFun {git branch -a}
Set-Alias -Name gba -Value GitBranchAllFun
# alias gbv
Function GitBranchAllVerboseFun {git branch -vv}
Set-Alias -Name gbv -Value GitBranchAllVerboseFun
# alias gcmpt 'git checkout $(git_main_branch) && git pull && git fetch --tags'
Function GitCheckOutMainAndFetchAllTagsFun {git checkout $(git config --get init.defaultBranch) ; git pull --verbose; git fetch --tags}
Set-Alias -Name gcmpt -Value GitCheckOutMainAndFetchAllTagsFun
# alias gdct 'git describe --tags $(git rev-list --tags --max-count=1)'
Function GitDescribeTagsLatestFun { git describe --tags $(git rev-list --tags --max-count=1) }
Set-Alias -Name gdct -Value GitDescribeTagsLatestFun
# alias gds 'git diff --staged'
Function GitDifferentStagedFun { git diff --staged }
Set-Alias -Name gds -Value GitDifferentStagedFun
# alias gdw 'git diff --word-diff'
Function GitDifferentWordDiffFun { git diff --word-diff }
Set-Alias -Name gdw -Value GitDifferentWordDiffFun
# alias gdt 'git diff-tree --no-commit-id --name-only -r'
Function GitDifferentTreeNoCommitIdNameOnlyFun { git diff-tree --no-commit-id --name-only -r }
Set-Alias -Name gdt -Value GitDifferentTreeNoCommitIdNameOnlyFun
# alias gdca 'git diff --cached'
Function GitDifferentCachedFun { git diff --cached }
Set-Alias -Name gdca -Value GitDifferentCachedFun
# alias gdcw 'git diff --cached --word-diff'
Function GitDifferentCachedWordDiffFun { git diff --cached --word-diff }
Set-Alias -Name gdcw -Value GitDifferentCachedWordDiffFun
# alias gdup 'git diff @{upstream}'
Function GitDifferentAtUpstreamFun { git diff '@{upstream}' }
Set-Alias -Name gdup -Value GitDifferentAtUpstreamFun
# alias gcmb to checkout main branch
Function GitCheckoutBranchMainFun {git checkout $(git config --get init.defaultBranch)}
Set-Alias -Name gcmb -Value GitCheckoutBranchMainFun
# alias gcrurl 'git config --get remote.origin.url'
Function GitGetConfigRemoteOriginUrlFun {git config --get remote.origin.url}
Set-Alias -Name gcrurl -Value GitGetConfigRemoteOriginUrlFun
# alias gcdfx
Function GitCleanNormallyForceUseIgnoreFun {git clean -d -f -x}
Set-Alias -Name gcdfx -Value GitCleanNormallyForceUseIgnoreFun
# alias grhh
Function GitRestHardHeadFun {git reset --hard HEAD}
Set-Alias -Name grhh -Value GitRestHardHeadFun
# alias grshb
Function GitRestSoftHeadBeforeFun {git reset --soft HEAD^}
Set-Alias -Name grshb -Value GitRestSoftHeadBeforeFun