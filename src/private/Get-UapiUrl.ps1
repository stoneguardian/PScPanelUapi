function Get-UapiUrl {
    [CmdletBinding()]
    param (
        [parameter()]
        [string] $Action = 'execute',

        [parameter(Mandatory)]
        [string] $Module,

        [parameter(Mandatory)]
        [string] $Function,

        [parameter()]
        [hashtable] $InputParameters
    )
    
    begin {
    }
    
    process {
        $baseUrl = Get-Connection | Select-Object -ExpandProperty BaseUrl

        if([string]::IsNullOrEmpty($baseUrl))
        {
            Write-Error "Current connection has not been set, please do so with 'Set-Connection' before trying again" -ErrorAction Stop
        }

        $url = "$baseUrl/$Action/$Module/$Function"

        if($PSBoundParameters.ContainsKey('InputParameters'))
        {
            $keyValueList = $InputParameters.Keys.ForEach{ "$_=$($InputParameters[$_])" }
            $url += "?$($keyValueList -join '&')"
        }

        $url # Write-Output
    }
    
    end {
    }
}