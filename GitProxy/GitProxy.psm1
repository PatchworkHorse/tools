class GitAliasAttribute : System.Attribute {
    [string]$Alias
    GitAliasAttribute([string]$alias) {
        $this.Alias = $alias
    }
}

function Initialize-GitAliases {
    # Register the git aliases for each function wearing the GitAlias attribute
    Get-AvailableFunctions | ForEach-Object {
        $alias = $_.ScriptBlock.Attributes | Where-Object { $_.GetType().Name -eq "GitAliasAttribute" } | Select-Object -ExpandProperty Alias
        & git config --global alias.$alias "!powershell -NoProfile -Command Invoke-GitCommand -Command $alias"
    }

}

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
####

function HelloWorld {
    [GitAlias("hello")]
    param()

    Write-Host "Hello, World!"
} 

Export-ModuleMember -Function Initialize-GitAliases, Invoke-GitCommand
