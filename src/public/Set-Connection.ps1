function Set-Connection {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [uri] $LoginUrl,

        [Parameter(Mandatory)]
        [PSCredential] $Credential
    )
    
    begin {
    }
    
    process {
        if($LoginUrl.Scheme -ne "https")
        {
            Write-Error -Message "Given URL ($LoginUrl) is not https. HTTPS is required because we use Basic authentication against the API which is not encrypted" -ErrorAction Stop
        }

        $Script:Connection = @{ 
            BaseUrl = $LoginUrl.AbsoluteUri
            Credential = $Credential
        }

        # TODO: Store URI for autocomplete next time

    }
    
    end {
    }
}