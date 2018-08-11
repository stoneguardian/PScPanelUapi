function Remove-MailForwarder {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string[]] $ForwardedAddress
    )
    
    begin {
        $uapiModule = 'Email'
        $uapiFunction = 'delete_forwarder'
    }
    
    process {
        $existingForwarders = Get-MailForwarder

        foreach($address in $ForwardedAddress)
        {
            $existingForwarder = $existingForwarders |
                Where-Object { $_.Address -eq $address }

            if($null -eq $existingForwarder){ continue } # Start processing next address

            $inputParams = @{
                address = $address
                forwarder = $existingForwarder.ForwardedTo
            }

            $null = Get-UapiUrl -Module $uapiModule -Function $uapiFunction -InputParameters $inputParams |
                Invoke-UapiRestMethod -Method Post
        }
    }
    
    end {
    }
}