Properties {
    $ModuleName = 'PScPanelUapi'
    $SourceDirectory = "$PSScriptRoot\src"
    $OutputDirectoryBase = "$PSScriptRoot\release"
    $OutputDirectory = "$OutputDirectoryBase\$ModuleName"
    $DocsDirectory = "$PSScriptRoot\docs\en-US"
}

Task -name 'Clean' {
    if (Test-Path $OutputDirectoryBase)
    {
        $null = Remove-Item $OutputDirectoryBase -Recurse -Force
    }
}

Task -name 'StageFiles' -depends 'Clean' {
    $null = New-Item $OutputDirectory -ItemType Directory -Force

    # Files to copy
    Copy-Item -Path "$SourceDirectory\Configuration.psd1" -Destination "$OutputDirectory"
    Copy-Item -Path "$SourceDirectory\$ModuleName.psd1" -Destination "$OutputDirectory"
}

Task -name 'BuildModuleManifest' -depends 'StageFiles', 'BuildModuleFile' {
    $functionsToExport = (Get-ChildItem -Path "$SourceDirectory\public" -Filter '*.ps1' -File).BaseName

    Update-ModuleManifest -Path "$OutputDirectory\$ModuleName.psd1" -FunctionsToExport $functionsToExport
}

Task -name 'BuildModuleFile' -depends 'StageFiles' {
    $psm1File = "$OutputDirectory\$ModuleName.psm1"

    # Header
    '#' | Out-File $psm1File -Encoding utf8
    '# Autogenerated by psake' | Out-File $psm1File -Append -Encoding utf8
    "$('#') At: $(Get-Date -Format u) " | Out-File $psm1File -Append -Encoding utf8
    "$('#') Commit: $(git rev-parse HEAD)" | Out-File $psm1File -Append -Encoding utf8
    '#' | Out-File $psm1File -Append -Encoding utf8

    # Load classes
    if (Test-Path "$SourceDirectory\classes")
    {
        '# Classes' | Out-File $psm1File -Append -Encoding utf8    
        foreach ($file in (Get-ChildItem -Path "$SourceDirectory\classes" -Filter '*.ps1' -File))
        {
            Get-Content -Path $file.FullName -Encoding utf8 | Out-File $psm1File -Append -Encoding utf8
            "`n" | Out-File $psm1File -Append -Encoding utf8            
        }
    }

    # Load functions
    $privateFunctions = Get-ChildItem -Path "$SourceDirectory\private" -Filter '*.ps1' -File
    $publicFunctions = Get-ChildItem -Path "$SourceDirectory\public" -Filter '*.ps1' -File

    '# Functions' | Out-File $psm1File -Append -Encoding utf8

    foreach ($file in @(@($privateFunctions) + @($publicFunctions)))
    {
        Get-Content -Path $file.FullName -Encoding utf8 | Out-File $psm1File -Append -Encoding utf8
        "`n" | Out-File $psm1File -Append -Encoding utf8
    }

    # Load argumentcompleters
    if (Test-Path "$SourceDirectory\argumentcompleters")
    {

    }

    # Load post import functions

}

Task -name 'GenerateMarkdownHelp' {
    Import-Module "$SourceDirectory\$ModuleName.psd1" -Force

    $null = New-MarkdownHelp -Module $ModuleName -OutputFolder $DocsDirectory -ErrorAction SilentlyContinue
    $null = Update-MarkdownHelp -Path $DocsDirectory

    Remove-Module $ModuleName
}

Task -name 'BuildExternalHelp' -depends 'StageFiles' {
    $null = New-ExternalHelp -Path $DocsDirectory -OutputPath "$OutputDirectory\en-US"
}


Task -name 'Build' -depends 'BuildModuleManifest', 'BuildModuleFile', 'BuildExternalHelp'

