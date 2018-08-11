function Format-UapiOutput {
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipeline)]
        [object[]] $FunctionOutput,

        [parameter()]
        [hashtable] $OutputMap
    )
    
    begin {
    }
    
    process {
        foreach($obj in $FunctionOutput)
        {
            $processedOutput = @{}
            foreach($key in $OutputMap.Keys){
                                     # Key from map , Value from object
                $processedOutput.Add($OutputMap.$key, $obj.$key)
            }
            
            [PSCustomObject] $processedOutput # Write-Output
        }

    }
    
    end {
    }
}