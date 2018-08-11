# Returns current connection
function Get-Connection {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
    }
    
    process {
        [PSCustomObject]$Script:Connection # Write-Output
    }
    
    end {
    }
}