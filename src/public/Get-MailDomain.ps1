function Get-MailDomain {
    [CmdletBinding()]
    param (
    )
    
    begin {
        $uapiModule = 'Email'
        $uapiFunction = 'list_mail_domains'
    }
    
    process {
        Get-UapiUrl -Module $uapiModule -Function $uapiFunction |
            Invoke-UapiRestMethod |
            Select-Object -ExpandProperty domain
    }
    
    end {
    }
}