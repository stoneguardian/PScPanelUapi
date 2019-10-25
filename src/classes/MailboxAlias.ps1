class  MailboxAlias
{
    [string] $Address
    [string] $Domain
    [string] $ForwardToAddress

    MailboxAlias([PSCustomObject]$uapiForwarder, [string]$domain)
    {
        $this.Address = $uapiForwarder.dest
        $this.Domain = $domain
        $this.ForwardToAddress = $uapiForwarder.forward
    }

    [string]ToString(){ return $this.Address }
}