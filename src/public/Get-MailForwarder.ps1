function Get-MailForwarder {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]] $Domain = (Get-MailDomain) # Default to all
    )
    
    begin {
        $uapiModule = 'Email'
        $uapiFunction = 'list_forwarders'

        $outputMap = @{
            'dest' = 'Address'
            'forward' = 'ForwardedTo'
        }
    }
    
    process {
        foreach($mailDomain in $Domain)
        {
            Get-UapiUrl -Module $uapiModule -Function $uapiFunction -InputParameters @{ domain = $mailDomain } |
                Invoke-UapiRestMethod |
                Format-UapiOutput -OutputMap $outputMap
        }
    }
    
    end {
    }
}