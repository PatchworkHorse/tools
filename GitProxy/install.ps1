Copy-Item -Path $PSScriptRoot -Destination $env:PSModulePath.Split(';')[0] -Recurse
Import-Module GitProxy
Install-GitAliases
