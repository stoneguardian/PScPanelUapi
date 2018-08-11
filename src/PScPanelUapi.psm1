$publicFunctions = Get-ChildItem -Path "$PSScriptRoot\public" -Filter "*.ps1" -File
$privateFunctions = Get-ChildItem -Path "$PSScriptRoot\private" -Filter "*.ps1" -File

foreach ($func in $publicFunctions) 
{
    . $func.FullName
    Export-ModuleMember -Function $func.BaseName
}

foreach($func in $privateFunctions)
{
    . $func.FullName
}