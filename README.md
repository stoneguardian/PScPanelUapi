# PScPanelUapi

PowerShell module to wrap the cPanel UAPI ([cPanel docs](https://documentation.cpanel.net/display/DD/Guide+to+UAPI))

Because the module uses Basic authentication the module requires https://-URLs to the API.

All exported functions are prefixed with "Uapi" when imported, the files (and function names defined in the files) does not require this added.