#Requires -Version 3.0

<#
  .Notes
    Helper functions and shims for older versions of PowerShell
 #>

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
  Get-EventSubscriber | Where SourceObject -eq $webClient | Unregister-Event -Force

  return $True
}


# see helper

Get-Help Expand-Path
Get-Help Get-RelativeRootDirectory
Get-Help Invoke-FileDownload

Function Get-ScriptSelfName () {
  <#
  .Notes
    if want script root, please use $PSScriptRoot
  #>
  Return (Get-ChildItem "$PSCommandPath").Name
}

Function Get-ScriptFullPath () {
  <#
    .Notes
      this will return as $PSCommandPath
  #>
  Return (Join-Path $PSScriptRoot (Get-ScriptSelfName))
  # powershell 3.0 remove $MyInvocation
  # Return (Split-Path -Parent $MyInvocation.MyCommand.Definition)
}

Write-Host "now PSScriptRoot: ${PSScriptRoot}"
Write-Host "see PSCommandPath ${PSCommandPath}"
Write-Host "see input $$"
Write-Host "Get-ScriptSelfName $(Get-ScriptSelfName)"

Write-Host "Function Get-ScriptFullPath"
$script_run_path = Get-ScriptFullPath
Write-Host "Get-ScriptFullPath: ${script_run_path}"

if(Compare-StrIsBlank("")){
  Write-Host "Compare-StrIsBlank check str is blank"
}
else {
  Write-Host "Compare-StrIsBlank check str is not blank"
}