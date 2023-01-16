<#
  .SYNOPSIS
  portable-exec

  .DESCRIPTION
  portable-exec.ps1

  .PARAMETER help
  use -help show Get-Help

  .PARAMETER env
  use -env to show env

  .PARAMETER gitProj
  use -env to init git project ignore and gitattributes

  .PARAMETER zMakefile
  use -zMakefile to init powershell z-makefile

 .INPUTS
  String

 .OUTPUTS
  PSCustomObject

 .EXAMPLE
  portable-exec -cpname one,two
#>
[CmdletBinding()]
  param (
    [switch]$help,
    [switch]$env,
    [switch]$gitProj,
    [switch]$zMakefile
    # [Parameter(
    #   Mandatory=$False,
    #   HelpMessage="Parameter missing: -path as string")]
    # [string]$path,
    # [Parameter(
    #   Mandatory=$False,
    #   HelpMessage="Parameter missing: -MainExec as string")]
    # [string]$mainExec,
    # [Parameter(
    #   Mandatory=$False,
    #   HelpMessage="Parameter missing: -BuildTarget must set"
    # )]
    # [ValidateSet(
    #   "Android", "iOS",
    #   IgnoreCase=$False
    # )]
    # [string]$buildTarget,
    # [Parameter(
    #   Mandatory=$False,
    #   HelpMessage="Enter more computer name to query")]
    # [ValidateCount(1,3)] # only count as 1-3
    # [Alias('cpname')]
    # [string[]]$computerName,
    # [ValidateSet(1,2,3,4)] # only let ddrivetype use 1,2,3,4
    # [int]$drivetype = 3
  )

Function Get-ScriptSelfName () {
  <#
  .Notes
    if want script root, please use $PSScriptRoot
  #>
  Return (Get-ChildItem "$PSCommandPath").Name
}

## import module
# Import-Module (Join-Path $PSScriptRoot "xxx.psm1")

Function Get-DateTagFull {
  Return (Get-Date).ToString('yyyy-MM-dd-HH-mm-ss')
}

function Start-Exec {
  <#
  .SYNOPSIS
   Start-Exec and can get out of exec

  .DESCRIPTION
   this method can run exec and get return.

  .PARAMETER workingDir
   set exec run working dir

  .PARAMETER exec
   set exec path

  .PARAMETER arguments
   exec run arguments

  .PARAMETER notShowOut
   default is show out

  .PARAMETER isUseShellExecute
   is use shell execute, default $False

  .OUTPUTS
   if notShowout be $True will out put array
      0 is exitCode
      1 is std out
      2 is std err
   default is
      0 is exitCode

  .Notes
   like
   $processOptions = @{
     WorkingDirectory = $PSScriptRoot
     FilePath = "$unityEditorCliPath"
     ArgumentList = "-quit -batchmode -nographics --version"
     # RedirectStandardInput = "TestSort.txt"
     # RedirectStandardOutput = $outPut
     # RedirectStandardError = $outPutErr
     UseNewEnvironment = $False
     NoNewWindow = $False
     Wait = $True
     PassThru = $True
   }
   $proc = Start-Process @processOptions

   most use like
    $runRes = Start-Exec -workingDir $PSScriptRoot `
      -exec "ping"`
      -arguments "-c"
   or want out
    $runRes = Start-Exec -workingDir $PSScriptRoot `
      -exec "ping"`
      -notShowOut $True `
      -arguments "-c"
    $runRes[1] # is stdout
    $runRes[2] # is stderr

  #>
  param (
    [Parameter(
      Mandatory=$True,
      HelpMessage="Parameter missing: -workingDir as string"
    )]
    [string]$workingDir,
    [Parameter(
      Mandatory=$True,
      HelpMessage="Parameter missing: -exec as string"
    )]
    [string]$exec,
    [string]$arguments,
    [bool]$notShowOut = $False,
    [bool]$isUseShellExecute = $False
  )
  $proStartInfo = New-Object System.Diagnostics.ProcessStartInfo
  # $proStartInfo.CreateNoWindow = $true
  $proStartInfo.WorkingDirectory = $workingDir
  $proStartInfo.FileName = $exec
  $proStartInfo.RedirectStandardError = $true
  $proStartInfo.RedirectStandardOutput = $true
  $proStartInfo.UseShellExecute = $isUseShellExecute
  if (($arguments -ne $Null) -and ($arguments -ne ""))
  {
    $proStartInfo.Arguments = $arguments
  }
  $proProcess = New-Object System.Diagnostics.Process
  $proProcess.StartInfo = $proStartInfo
  if ($notShowOut) {
    $proProcess.Start() | Out-Null
    $proProcess.WaitForExit()
    $stdout = $proProcess.StandardOutput.ReadToEnd()
    $stderr = $proProcess.StandardError.ReadToEnd()
    $proProcess.ExitCode
    $stdout
    Return $stderr
  } else {
    # 给System.Diagnostics.Process添加OutputDataReceived事件的订阅
    # $Action = { Write-Host "do aciton" }
    $changed = Register-ObjectEvent -InputObject $proProcess -EventName OutputDataReceived -Action {
      Write-Host $Event.SourceEventArgs.Data
    }
      # 打印源进程的输出信息
      # Write-Host $Event.SourceEventArgs.Data
      # 注意： $Event输入自动化变量：
      # 包含了 Register-ObjectEvent 命令的Action参数中的上下文，
      # 尤其是Sender和Args

      # .Sender默认是Object对象，需要转换成Process对象
      #$p = [System.Diagnostics.Process]$Event.Sender
    $proProcess.Start() | Out-Null
    $proProcess.BeginOutputReadLine()
    $proProcess.WaitForExit()
    Remove-Job $changed -Force
    Return $proProcess.ExitCode
  }
}

Function ConvertFrom-ParameterStr {
  Param(
    [AllowEmptyString()]
    [Parameter(
      Mandatory=$True
    )]
    [string]$parameter,
    [Parameter(
      Mandatory=$True
    )]
    [string]$default
  )
  if (($parameter -eq "") -or ($parameter -eq $Null)) {
    Return $default
  } else {
    Return $parameter
  }
}

Function Compare-StrIsBlank {
  <#
  .SYNOPSIS
  Compare-StrIsBlank compare str is blank

  .PARAMETER InputObject
  input object, must be string

  .OUTPUTS
  bool

  .EXAMPLE
  if (Compare-StrIsBlank($path)){
    $path = $PSScriptRoot
  }
  #>
  Param(
    [AllowEmptyString()]
    [string]$InputObject
  )
  if (($InputObject -eq "") -or ($InputObject -eq $Null)) {
    Return $True
  } else {
    Return $False
  }
}

Function Join-PathByList([string[]]$pathList, [bool]$showError=$False) {
  if ($pathList.count -eq 0) {
    if ($showError) {
      $host.UI.WriteErrorLine("Remove-FileByList not run by empty List")
    }
    Return
  }
  if ($pathList.count -eq 1) {
    Return $pathList[0]
  }
  $fullPath = $pathList[0]
  for ($i = 1; $i -lt $pathList.Count; $i++) {
    $fullPath = Join-Path -Path $fullPath -ChildPath $pathList[$i]
  }
  Return $fullPath
}

Function Test-PathNotExist([string]$path, [bool]$showError=$False, [string]$errorMsgTag="") {
  if (($path -eq "") -or ($path -eq $Null)) {
    if ($showError) {
      $host.UI.WriteErrorLine("${errorMsgTag} path not test by empty")
    }
    Return $True
  } else {
    if (Test-Path $path) {
      Return $False
    } else {
      if ($showError) {
        $host.UI.WriteErrorLine("${errorMsgTag} path not exists at: $path")
      }
      Return $True
    }
  }
}

Function Test-PathOrMkdir([string]$path, [bool]$showError=$False) {
  if (($path -eq "") -or ($path -eq $Null)) {
    if ($showError) {
      $host.UI.WriteErrorLine("Test-PathOrMkdir not run by empty path")
    }
    Return
  } else {
    if (Test-Path $path) {
      Return
    } else {
      try {
        New-Item -Force -ItemType Directory -Path $path
      }
      catch {
        $host.UI.WriteErrorLine("Test-PathOrMkdir can not New dir at path: $path")
        if ($showError) {
          $host.UI.WriteErrorLine("can not New dir by: $_")
        }
      }
    }
  }
}
function Remove-FileOrDirByList {
  param (
    [string[]]$removeList,
    [bool]$force=$True,
    [bool]$showWarning=$True,
    [bool]$showError=$True,
    [bool]$showCleanInfo=$True
  )
  if ($removeList.count -eq 0) {
    if ($showError) {
      $host.UI.WriteErrorLine("Remove-FileByList not run by empty List")
    }
    Return
  }
  try {
    foreach ($removeItem in $removeList) {
      if (Test-Path $removeItem) {
        if ($showCleanInfo){
          Write-Host "Remove-FileOrDirByList path: ${removeItem}"
        }
        if ($force) {
          Remove-Item -Force -Recurse -Path $removeItem
        } else {
          Remove-Item -Recurse -Path $removeItem
        }
      } else {
        if ($showWarning) {
          $host.UI.WriteErrorLine("Remove-FileByList path not exists: $removeItem")
        }
      }
    }
  }
  catch {
    $host.UI.WriteErrorLine("Remove-FileByList run error at ${removeList}")
    if ($showError) {
      $host.UI.WriteErrorLine("can not remove by: $_")
    }
  }
}

function Find-GitBranchInfo {
  Return (git rev-parse --abbrev-ref HEAD)
}

function Find-GitCommitId {
  Return (git rev-parse HEAD)
}

function Find-GetCommitIdShort {
  Return (git rev-parse --short HEAD)
}

function Find-BuildMarkTag {
  "$(Get-DateTagFull)-$(Find-GitBranchInfo)-$(Find-GetCommitIdShort)"
}

# $buildGitBranchInfo = Find-GitBranchInfo
# $buildGitCommitId = Find-GitCommitId
# $buildGitCommitIdShort = Find-GetCommitIdShort
# $buildMarkTag = "$(Find-BuildMarkTag)"

<#
  .Notes
    define var for build
#>

# $DefaultMainExec =
#   "cmake"

# $mainExec =
#    ConvertFrom-ParameterStr $mainExec $DefaultMainExec

# if (Compare-StrIsBlank($path)){
#   $path = $PSScriptRoot
# }
# if (Test-PathNotExist $path $True "arg -path set"){
#   Return
# }

$readmeTemplate="# this project"

$projectTemplateFolder = Join-PathByList $PSScriptRoot, "templates"

if ($env) {
  Write-Host "===== Show env begin ====="
  Write-Debug "this message only in debug mode, and can break this script"

  Write-Verbose -Message "This script tools root path: ${PSScriptRoot}"

  Write-Host "Build as exec args"
  Write-Host ""
  Write-Host "DefaultMainExec        $DefaultMainExec"
  Write-Host ""
  Write-Host "projectTemplateFolder                   $projectTemplateFolder"
  # Write-Host "mainExec               $mainExec"
  Write-Host ""
  # Write-Host "Build mark"
  # Write-Host " this build only support windows at powershell"
  # Write-Host "buildGitBranchInfo         ${buildGitBranchInfo}"
  # Write-Host "buildGitCommitId           ${buildGitCommitId}"
  # Write-Host "buildGitCommitIdShort      ${buildGitCommitIdShort}"
  # Write-Host "buildMarkTag               ${buildMarkTag}"
  # Write-Host ""
  Write-Host "===== Show env end ====="
  Return
}

if ($help) {
  Get-Help $PSCommandPath
  Return
}

# $runRes = Start-Exec -workingDir $PSScriptRoot `
# -exec ${mainExec} `
# -arguments "--help"
# -notShowOut $True `

function Step-TestTargetFileOrNew {

  param (
    [Parameter(
      Mandatory=$True,
      HelpMessage="Parameter missing: -targetPath as string"
    )]
    [string]$targetPath,
    [Parameter(
      Mandatory=$True,
      HelpMessage="Parameter missing: -targetDesc as string"
    )]
    [string]$targetDesc,
    [string]$contentTemplatePath,
    [string]$content
  )

  if (Test-PathNotExist "${targetPath}") {
    if (($content -eq $Null) -or ($content -eq "")) {
      Get-Content -Path "${contentTemplatePath}" `
      | Set-Content -Path "${targetPath}"
    } else {
      echo "${content}" | Set-Content "${targetPath}"
    }

    Write-Host "-> just init ${targetDesc} at: ${targetPath}"
  } else {
    Write-Warning "-> exist ${targetDesc} at: ${targetPath}"
  }
}

# -gitProj
if ($gitProj) {
  $gitTemplateFolder = Join-PathByList $projectTemplateFolder, "git-template"
  Step-TestTargetFileOrNew -targetPath ".gitignore" `
    -targetDesc "git ignore" `
    -contentTemplatePath (Join-PathByList $gitTemplateFolder, "git-ignore-global-template")

  Step-TestTargetFileOrNew -targetPath ".gitattributes" `
    -targetDesc "git attributes" `
    -contentTemplatePath (Join-PathByList $gitTemplateFolder, "git-gitattributes-template")

  Step-TestTargetFileOrNew -targetPath "README.md" `
    -targetDesc "main doc READM.md" `
    -content "${readmeTemplate}"
}

# -zMakefile
if ($zMakefile) {
  $zMakefileTemplateFolder = Join-PathByList $projectTemplateFolder, "z-make-template"

  Step-TestTargetFileOrNew -targetPath "z-make-file.psm1" `
    -targetDesc "z-make-file module" `
    -contentTemplatePath (Join-PathByList $zMakefileTemplateFolder, "z-make-file.psm1")

  Step-TestTargetFileOrNew -targetPath "z-make-file.ps1" `
    -targetDesc "z-make-file" `
    -contentTemplatePath (Join-PathByList $zMakefileTemplateFolder, "z-make-file.ps1")
}