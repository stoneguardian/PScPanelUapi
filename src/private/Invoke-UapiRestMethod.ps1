function Invoke-UapiRestMethod
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string] $Url,

        [Parameter()]
        [ValidateSet('Get', 'Post')]
        [string] $Method = 'Get'
    )
    
    begin
    {
    }
    
    process
    {
        $credential = Get-Connection | Select-Object -ExpandProperty Credential

        if ($null -eq $credential)
        {
            Write-Error "Current connection has not been set, please do so with 'Set-Connection' before trying again" -ErrorAction Stop
        }

        # Create basic auth header for request
        $combined = "$($Credential.UserName):$($Credential.GetNetworkCredential().Password)"
        $combinedBytes = [System.Text.UTF8Encoding]::UTF8.GetBytes($combined)
        $authorizationHeader = @{ Authorization = "Basic $([System.Convert]::ToBase64String($combinedBytes))" } 

        $requestParams = @{
            Method  = $Method
            Uri     = $Url
            Headers = $authorizationHeader
        }

        $result = Invoke-RestMethod @requestParams

        if ($null -eq $result.errors)
        {
            $result.data # Write-Output
        }
        else
        {
            Write-Error -Message "Something went wrong... :`n$($result.errors)"
        }
    }
    
    end
    {
    }
}