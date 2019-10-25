class Mailbox 
{
    [string] $Address
    [string] $Domain
    [bool] $NoQuota
    [long] $DiskUsedInBytes
    [long] $DiskQuotaInBytes
    [int] $PrecentageQuotaUsed
    [MailboxAlias[]] $Aliases = @()

    Mailbox([PSCustomObject]$uapiMailBox)
    {
        $this.Address = $uapiMailBox.email
        $this.Domain = $uapiMailBox.domain
        $this.NoQuota = $uapiMailBox.diskquota -eq 'unlimited'
        $this.DiskUsedInBytes = $uapiMailBox._diskused

        if ($this.NoQuota)
        {
            $this.DiskQuotaInBytes = 0
            $this.PrecentageQuotaUsed = 0
        }
        else 
        {
            $this.DiskQuotaInBytes = $uapiMailBox._diskquota
            $this.PrecentageQuotaUsed = ($this.DiskUsedInBytes * 100) / $this.DiskQuotaInBytes    
        }

        $this.Aliases = @(Get-MailboxAlias -Domain $this.Domain).Where{ $_.ForwardToAddress -eq $this.Address }
    }

    [string]ToString(){ return $this.Address }
}