# Functions wearing this attribute will be discovered and registered as git commands.
class GitAliasAttribute : System.Attribute {
    [string]$Alias
    GitAliasAttribute([string]$alias) {
        $this.Alias = $alias
    }
}

# Discovers and registers all functions wearing the GitAlias attribute as git commands
# Todo: We duplicate searching for functions in the module. Instead we should update Get-AvailableFunctions to also include the GitAlias attribute value
function Initialize-GitAliases {
    Get-AvailableFunctions | ForEach-Object {
        $alias = $_.ScriptBlock.Attributes | Where-Object { $_.GetType().Name -eq "GitAliasAttribute" } | Select-Object -ExpandProperty Alias
        Write-Host "Registering git alias: $alias"
        & git config --global alias.$alias "!powershell -NoProfile -Command Invoke-GitCommand -Command $alias"
    }

}

# Returns all functions in the module that wear the GitAlias attribute
function Get-AvailableFunctions {
    Get-Command -Module $MyInvocation.MyCommand.Module.Name -CommandType Function | Where-Object {
        $_.ScriptBlock.Attributes | Where-Object { $_.GetType().Name -eq "GitAliasAttribute" }
    }
}

function Invoke-GitCommand {
    param(
        [string]
        [Parameter(Mandatory = $true)]
        $Command,
        [string]$Arguments
    )

    # Locate the function with the specified alias
    $func = Get-AvailableFunctions | Where-Object {
        $_.ScriptBlock.Attributes | Where-Object { $_.GetType().Name -eq "GitAliasAttribute" -and $_.Alias -eq $Command }
    }

    if ($func) {
        # Invoke the function with the specified arguments
        & $func.Name $Arguments
    } else {
        Write-Error "Unknown git command: $Command"
    }
}

####
# Below are the functions that will be available as git commands
# Be sure to add the GitAlias attribute to each function so it will be resolved as a git command
####

function HelloWorld {
    [GitAlias("hello")]
    param()

    Write-Host "Hello, World! GitProxy has been successfully installed."
} 

function PruneMerged {
    [GitAlias("prune-merged")]
    param()

    # Todo: We may need to force deletion (-D) if we're confident that the branches are merged remotely 
    foreach ($b in (git branch --merged main | Where-Object { $_ -notin ("* main", "* master") } )) {
         git branch -d $b.Trim()
    }
}

# Keep this at the end of the file
Export-ModuleMember -Function Initialize-GitAliases, Invoke-GitCommand, Get-AvailableFunctions
