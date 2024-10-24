# Copies the module to the first path in the PSModulePath environment variable and imports the module.
Copy-Item -Path $PSScriptRoot -Destination $env:PSModulePath.Split(';')[0] -Recurse -Force

# Remove any pre-existing module and import the new module. (May be able to remove this since we force import in a subsequent step)
Uninstall-Module GitProxy -Force -ErrorAction SilentlyContinue

# Import the module
Import-Module -Name .\GitProxy.psm1 -Force

# Register the git aliases
Initialize-GitAliases
