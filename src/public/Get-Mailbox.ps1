function Get-Mailbox
{
    [CmdletBinding()]
    param (
    )
    
    begin
    {
        $uapiModule = 'Email'
        $uapiFunction = 'list_pops_with_disk'

        $apiUrl = Get-UapiUrl -Module $uapiModule -Function $uapiFunction
    }
    
    process
    {
        $result = Invoke-UapiRestMethod -Url $apiUrl -Method 'Get'
        foreach ($item in $result)
        {
            [Mailbox]::new($item) # Write-Output
        }
    }
    
    end
    {
    }
}