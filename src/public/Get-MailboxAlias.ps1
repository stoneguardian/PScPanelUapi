function Get-MailboxAlias
{
    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]] $Domain = (Get-MailDomain) # Default to all
    )
    
    begin
    {
        $uapiModule = 'Email'
        $uapiFunction = 'list_forwarders'
    }
    
    process
    {
        foreach ($mailDomain in $Domain)
        {
            $apiUrl = Get-UapiUrl -Module $uapiModule -Function $uapiFunction -InputParameters @{ domain = $mailDomain } 
            $result = Invoke-UapiRestMethod -Url $apiUrl
            
            foreach ($item in $result)
            {
                [MailboxAlias]::new($item, $mailDomain)
            }
        }
    }
    
    end
    {
    }
}