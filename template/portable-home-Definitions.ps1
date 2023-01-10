#Requires -Version 3.0

<#
    .SYNOPSIS
        Definitions for a portable development environment
    .NOTES
        To update a package, update its name and its URL, then execute
            Remove-foo.ps1
            Setup-bar.ps1
        The configuration directory specified in `$PortableHomeDirectory`
        will be untouched.
 #>

# Settings folder for portable-home
$PortabelHomeDirectoryName =
 'portable-home'
$PortableHomeDirectory =
 ".\$PortabelHomeDirectoryName"

#Locations of portable-home SDK downloads
$PortableHomeSDKDirectory =
    ".\portable-home-sdk-windows"
$PortableHomeSDKBinariesDirectories = @(
    "$PortableHomeSDKDirectory\tools",
    "$PortableHomeSDKDirectory\platform-tools"
)

### Tools Section. Shouldnt need to change ##

##7z File Expander
$7z =
 '7z1900-extra'

#Autgenerated from above
$7zInstaller =
 "$7z.7z"
$7zURL =
 "http://d.7-zip.org/a/$7zInstaller"
$7zExecutable =
 '7za.exe'
#$7zExtractFile =
#    "x64\$7zExecutable"	#64 bit version if desired
$7zExtractFile =
 "$7zExecutable"
$7zBootStrapURL =
'https://www.7-zip.org/a/7zr.exe'
$7zBootStrapExec =
'7zr.exe'