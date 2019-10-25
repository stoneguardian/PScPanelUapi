function Set-Connection
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = 'FromCache')]
        [string] $Alias,

        [Parameter(Mandatory, ParameterSetName = 'New')]
        [uri] $LoginUrl,

        [Parameter(Mandatory, ParameterSetName = 'FromCache')]
        [Parameter(Mandatory, ParameterSetName = 'New')]
        [PSCredential] $Credential,

        [Parameter(ParameterSetName = 'New')]
        [switch] $Save,

        [Parameter(ParameterSetName = 'New')]
        [string] $AsAlias
    )
    
    begin
    {
        $moduleConfig = Import-Configuration
    }
    
    process
    {
        if ($PSCmdlet.ParameterSetName -eq 'FromCache')
        {
            if ($moduleConfig.SavedConnections.Keys.Count -eq 0)
            {
                Write-Error -Message "No connections have been saved" -ErrorAction Stop
            }
            elseif ($moduleConfig.SavedConnections.ContainsKey($Alias))
            {
                $Script:Connection = @{
                    BaseUrl    = $moduleConfig.SavedConnections[$Alias]
                    Credential = $Credential
                }
                return #
            }
            else 
            {
                Write-Error -Message "Found no saved connection with alias '$Alias'" -ErrorAction Stop
            }
        }
        # Else .ParameterSet -eq 'New'
        if ($LoginUrl.Scheme -ne "https")
        {
            Write-Error -Message "Given URL ($LoginUrl) is not https. HTTPS is required because we use Basic authentication against the API which is not encrypted" -ErrorAction Stop
        }

        $Script:Connection = @{ 
            BaseUrl    = $LoginUrl.AbsoluteUri
            Credential = $Credential
        }

        # TODO: Store URI for autocomplete next time
        if ($Save)
        {
            if ([string]::IsNullOrWhiteSpace($AsAlias))
            {
                Write-Error -Message "Parameter AsAlias not given, cannot save url"
                return
            }

            $moduleConfig.SavedConnections[$AsAlias] = $LoginUrl.AbsoluteUri
            $moduleConfig | Export-Configuration
        }
    }
    
    end
    {
    }
}