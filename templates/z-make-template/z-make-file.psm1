<#
  .Notes
    Helper functions and shims for older versions of PowerShell
#>

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

Function Compare-StrIsInteger () {
  <#
  .SYNOPSIS
  Compare-StrIsInteger to compare str is integer

  .PARAMETER InputObject
  must not be empty
  #>
  Param (
    [AllowEmptyString()]
    [Parameter(
      Mandatory=$True
    )]
    [string]$InputObject
  )

  if ($InputObject -match "^\d+$" ) {
    Return $True
  } else {
    Return $False
  }
}

Function Compare-StrIsFloat {
  <#
  .SYNOPSIS
  Compare-StrIsFloat to compare str is float

  .PARAMETER InputObject
  must not be empty
  #>
  Param(
    [AllowEmptyString()]
    [Parameter(
      Mandatory=$True
    )]
    [string]$InputObject
  )
  if ($InputObject -match "^\d+\.\d+$") {
    Return $True
  } else {
    Return $False
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

Function Test-ParameterStrNotInList([string]$target, [string[]]$list, [bool]$showError=$True) {
  if (($target -eq "") -or ($target -eq $Null)) {
    if ($showError){
      $host.UI.WriteErrorLine("Test-ParameterStrNotInList -taget must not empty")
    }
    Return $True
  }
  if (($list -eq $Null) -or ($list.count -eq 0)) {
    if ($showError) {
      $host.UI.WriteErrorLine("Test-ParameterStrNotInList -list count must not empty")
    }
    Return $True
  }
  foreach ($item in $list) {
    if (($item -eq $Null) -or ($item -eq "")) {
      continue
    }
    if ($item -eq $target) {
      Return $False
    }
  }
  if ($showError) {
    $host.UI.WriteErrorLine("Test-ParameterStrNotInList $target not in list")
  }
  Return $True
}

function Expand-Path
 {
   <#
   .SYNOPSIS
     Expands a relative path into an absolute path.

   .DESCRIPTION
     Expands a relative path to an absolute path

   .PARAMETER Path
     for expands path

   .INPUTS
     String

   .OUTPUTS
     String

   .EXAMPLE
     Expand-Path -Path <path>
   #>

   [OutputType([String])]
   Param (
       [Parameter(
         Mandatory=$true,
         HelpMessage="need Expand-Path by -Path")]
       [String]
       $Path
   )
   $ResolvePathParameter = @{
       Path = $Path;
       ErrorAction = 'SilentlyContinue';
       ErrorVariable = 'ResolveError';
   }
   $ResolvedPath =
       Resolve-Path @ResolvePathParameter
   if (!($ResolvedPath))
   {
       $ResolvedPath =
           $ResolveError[0].TargetObject
   }
   return "$ResolvedPath"
 }

 function Get-RelativeRootDirectory
 {
   <#
   .SYNOPSIS
     Returns the first directory name in a relative path.

   .DESCRIPTION
     Expands a relative path to an absolute path

   .PARAMETER RelativePath
     for get path root directory

   .INPUTS
     String

   .OUTPUTS
     String

   .EXAMPLE
     Get-RelativeRootDirectory -RelativePath <path>
   #>

   [OutputType([String])]
   Param(
       [Parameter(
         Mandatory=$true,
         HelpMessage="need RelativePath by -RelativePath")]
       [String]
       $RelativePath
   )

   $Path =
       Expand-Path -Path $RelativePath
   $RelativePath =
       $Path.Replace($PWD, '')

   $Elements =
       $RelativePath.Split('\')
   $Directory =
       $Elements[0]

   if (!($Directory))
   {
       $Directory =
           $Elements[1]
   }

   return $Directory
 }

 <#
   .NOTES
   An `Expand-Archive` shim for older PowerShells
 #>
 if (!(Get-Command -Name 'Expand-Archive' `
                    -ErrorAction SilentlyContinue))
  {
      $ExpandArchiveIsShimmed =
          $true

      <#
          .SYNOPSIS
              Unpacks an archive.
      #>
      function Expand-Archive
      {
          Param(
              [Parameter(
               Mandatory=$true,
               HelpMessage="need Path by -Path")]
              [String]
              $Path
          )

          if (Test-Path -Path $Path)
          {
              $Path =
                  Expand-Path -Path $Path

              $NewObjectParameters = @{
                  TypeName = 'System.IO.FileInfo';
                  ArgumentList = $Path;
              }
              $DestinationDirectoryInfo =
                  New-Object @NewObjectParameters
              $DestinationDirectory =
                  ".\$($DestinationDirectoryInfo.BaseName)"
              $DestinationDirectory =
                  Expand-Path -Path $DestinationDirectory

              $NewItemParameters = @{
                  Path = $DestinationDirectory;
                  ItemType = 'Directory';
              }
              New-Item @NewItemParameters -Force | Out-Null

              $ShellApplication =
                  New-Object -Com 'shell.application'

              $Archive =
                  $ShellApplication.NameSpace($Path)
              $Destination =
                  $ShellApplication.NameSpace($DestinationDirectory)

              $Destination.CopyHere($Archive.Items())
          }
      }
  }

 function Invoke-FileDownload
 {
   <#
   .SYNOPSIS
     download file from url use System.Net.WebClient

   .DESCRIPTION
     use System.Net.WebClient to download file, and will show progress

   .PARAMETER Uri
     uri for download

   .PARAMETER OutFile
     out download file path

   .PARAMETER Cookies
     download cookies

   .INPUTS
     String

   .OUTPUTS
     Boolean

   .EXAMPLE
     Invoke-FileDownload -Uri <URL> -OutFile <Path>
   #>
   [CmdletBinding()]
   [OutputType([Boolean])]
   param (
     [Parameter(
       Mandatory=$true,
       HelpMessage="need Invoke-FileDownload by -Uri")]
     [uri] $Uri,

     [Parameter(
       Mandatory,
       HelpMessage="need Invoke-FileDownload by -OutFile")]
     [string] $OutFile,

     [Parameter(Mandatory=$false)]
     [System.Net.CookieContainer]
       $Cookies
   )

   $webClient = New-Object System.Net.WebClient

   $changed = Register-ObjectEvent -InputObject $webClient -EventName DownloadProgressChanged -Action {
     Write-Progress -Activity "Downloading...." -PercentComplete $eventArgs.ProgressPercentage -Status "Downloaded $($([System.Math]::Floor($eventArgs.BytesReceived/1048576)))M of $($([System.Math]::Floor($eventArgs.TotalBytesToReceive/1048576)))M"
   }

   if($Cookies){
     $Header =
       $Cookies.GetCookieHeader($Uri)
         $webClient.Headers.Add('Cookie', $Header)
   }

   $handle = $webClient.DownloadFileAsync($Uri, $PSCmdlet.GetUnresolvedProviderPathFromPSPath($OutFile))

   while ($webClient.IsBusy)
   {
     Start-Sleep -Milliseconds 10
   }

   Write-Progress -Activity "Downloaded $($Uri) to $($OutFile)" -Completed
   Remove-Job $changed -Force
   Get-EventSubscriber | Where-Object SourceObject -eq $webClient | Unregister-Event -Force

   return $True
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


Export-ModuleMember -Function `
  Start-Exec, `
  Compare-StrIsBlank, `
  Compare-StrIsInteger, `
  Compare-StrIsFloat, `
  ConvertFrom-ParameterStr, `
  Join-PathByList, `
  Test-PathNotExist, `
  Test-PathOrMkdir, `
  Remove-FileOrDirByList, `
  Test-ParameterStrNotInList, `
  Expand-Path, `
  Get-RelativeRootDirectory, `
  Invoke-FileDownload, `
  Find-GitBranchInfo, `
  Find-GitCommitId, `
  Find-GetCommitIdShort