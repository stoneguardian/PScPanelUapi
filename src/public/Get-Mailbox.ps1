function Get-Mailbox {
    [CmdletBinding()]
    param (
    )
    
    begin {
        $uapiModule = 'Email'
        $uapiFunction = 'list_pops'
    }
    
    process {
        Get-UapiUrl -Module $uapiModule -Function $uapiFunction |
            Invoke-UapiRestMethod |
            Where-Object { $_.login -ne 'Main Account' } |
            Select-Object -ExpandProperty 'email'
    }
    
    end {
    }
}