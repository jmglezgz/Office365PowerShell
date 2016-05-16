##########################################################################
# AUTHOR    : José Manuel González - josem@josemanuelgonzalez.net - @jmgonzalez_
# DATE      : 08/02/13
# VERSION   : 1.1
# UPDATE    : 01/03/15
# NOTES ------------------------------------------------------------------
# More Information and updates: https://technet.microsoft.com/en-us/library/dn568015.aspx
# Remember to setup Set-ExecutionPolicy RemoteSigned, more information: https://technet.microsoft.com/en-us/library/ee176961.aspx 
# V1.1 - Include Lync Service and Remove PSSessions
# ########################################################################

#Name of Office 365 domain to admin without extension
$DomainNameHost = "prodiel"   #<<<< ------------------CHANGE THIS PARAMETER TO WORK WITH DIFERENTS DOMAIN
$cred = Get-Credential

$SPOServiceURL = "https://"+ $DomainNameHost + "-admin.sharepoint.com"

# 2.Run these commands to connect to Office 365.
# Install Modules & Requirements: https://msdn.microsoft.com/es-es/library/jj151815.aspx#bkmk_installmodule
Import-Module MsOnline

Connect-MsolService -Credential $cred

# 4.Run these commands to connect to SharePoint Online. Replace domainhost with the actual value for your domain. For example, for litwareinc.onmicrosoft.com, the domainhost value is litwareinc.
Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking

Connect-SPOService -Url $SPOServiceURL -Credential $cred


# 5.Run these commands to connect to Skype for Business Online. A warning about increasing the WSMan NetworkDelayms value is expected the first time you connect and should be ignored.
Import-Module LyncOnlineConnector
$sfboSession = New-CsOnlineSession -Credential $credential
Import-PSSession $sfboSession

# 6.Run these commands to connect to Exchange Online.
$exchangeSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/powershell-liveid/" -Credential $cred -Authentication "Basic" -AllowRedirection

# 7.Run these commands to connect to the Compliance Center.
$ccSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -Credential $cred -Authentication Basic -AllowRedirection

#IMPORTANT NOTE: The text prefix "cc" is added to all Compliance Center cmdlet names 
#so you can run cmdlets that exist in both Exchange Online and the Compliance Center 
#in the same Windows PowerShell session. 
#For example, Get-RoleGroup becomes Get-ccRoleGroup in the Compliance Center. 

Import-PSSession $exchangeSession -DisableNameChecking
Import-PSSession $ccSession -Prefix cc

# 8.When you are ready to close down, run this compound command before you close the Windows PowerShell window.
#Remove-PSSession $sfboSession ; Remove-PSSession $exchangeSession ; Remove-PSSession $ccSession ; Disconnect-SPOService