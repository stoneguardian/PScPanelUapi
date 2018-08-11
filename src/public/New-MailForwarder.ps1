function New-MailForwarder {
    [CmdletBinding(DefaultParameterSetName = 'ToMailbox')]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string[]] $Address,

        [Parameter(Mandatory, ParameterSetName = 'ToMailbox')]
        [string] $DestinationAddress

        # TODO: add other options: https://documentation.cpanel.net/display/DD/UAPI+Functions+-+Email%3A%3Aadd_forwarder
    )
    
    begin {
        $uapiModule = 'Email'
        $uapiFunction = 'add_forwarder'

        $outputMap = @{
            'email' = 'Address'
            'forward' = 'ForwardedTo'
        }

        $paramSetForwardOptionMap = @{
            ToMailbox = 'fwd'
            Fail = 'fail'
            Drop = 'blackhole'
            ToApplication = 'pipe'
            ToUser = 'system'
        }
    }
    
    process {
        # Parameterset-specific validation
        if($PSCmdlet.ParameterSetName -eq 'ToMailbox')
        {
            if(-not ($DestinationAddress -in (Get-Mailbox)))
            {
                Write-Error -Message "Mailbox '$DestinationAddress' does not exist" -ErrorAction Stop
            }
        }

        foreach($sourceAddress in $Address)
        {
            $sourceDomain = $sourceAddress -split '@' |
                Select-Object -Last 1

            # Validate that we create a forwarder for a known domain
            if(-not ($sourceDomain -in (Get-MailDomain)))
            {
                Write-Error -Message "Unknown domain: $sourceDomain"
                continue # Start processing of next address
            }
    
            $existingForwarder = Get-MailForwarder -Domain $sourceDomain |
                Where-Object { $_.Address -eq $sourceAddress }

            if($null -ne $existingForwarder)
            {
                Write-Error -Message "Mail to '$sourceAddress' is already forwarded to '$($existingForwarder.ForwardedTo)'" -ErrorAction Stop
            }

            $inputParams = @{
                domain = $sourceDomain
                email = $sourceAddress
                fwdopt = $paramSetForwardOptionMap[$PSCmdlet.ParameterSetName]
            }

            switch($PSCmdlet.ParameterSetName)
            {
                'ToMailbox' { $inputParams['fwdemail'] = $DestinationAddress }
            }

            Get-UapiUrl -Module $uapiModule -Function $uapiFunction -InputParameters $inputParams |
                Invoke-UapiRestMethod |
                Format-UapiOutput -OutputMap $outputMap
        }

    }
    
    end {
    }
}