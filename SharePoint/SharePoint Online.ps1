##########################################################################
# AUTHOR    : José Manuel González - josem@josemanuelgonzalez.net - @jmgonzalez_
# DATE      : 10/10/15
# VERSION   : 1.0
# UPDATE    : 
# NOTES ------------------------------------------------------------------
# V1 Add-SPOSite ONLY work with Sites Collections
# ########################################################################

#1. Initial Parameters 
#Name of Office 365 domain to admin without extension
$DomainNameHost = "prodiel"  #  <<<< ------------------CHANGE THIS PARAMETER TO WORK WITH DIFERENTS DOMAIN
$SPOServiceURL = "https://"+ $DomainNameHost + "-admin.sharepoint.com"
#Service Credential
if ($cred -eq $null){
    $cred = Get-Credential
}


#2.Run these commands to connect to SharePoint Online. Replace domainhost with the actual value for your domain. For example, for litwareinc.onmicrosoft.com, the domainhost value is litwareinc.
Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking

Connect-SPOService -Url $SPOServiceURL -Credential $cred

#Import CSV
$path = "c:\it\in\"
$filename = "sharepoint_groups.csv"#<<<<<--------- INCLUDE CSV FILENAME. FOR EXLAMPLE ("bulk_input.csv")
$csv      = @()

#Import ABSOLUTE - CSV (c:\it\in)
$AbsolutePath = $path + $filename
$csv = Import-Csv -Path $AbsolutePath

#Loop through all items in the CSV

Foreach ($item in $csv)
{
        if ($item.Visitantes -ne ""){
            Add-SPOUser -Site $item.URL -Group "Visitantes de la Departamentos"  -LoginName $item.Visitantes
        }
        elseif ($item.Integrantes -ne ""){
            Add-SPOUser -Site $item.URL -Group "Integrantes de la Departamentos"  -LoginName $item.Integrantes
        }
        else{
            Write-Host "ERROR, $($item.URL), N/D"
        }
 }

# 8.When you are ready to close down, run this compound command before you close the Windows PowerShell window.
#Disconnect-SPOService

<#
################################################
SECUNDARY INFORMATION AND CMDLETS
################################################

#View groups inside a sharepoint group
Get-SPOUser -Site "https://prodiel.sharepoint.com" -Group "Integrantes de la intranet Colaborativa" #|Where-Object {$_.IsGroup -eq $false}


Remove-SPOUser -Site "https://prodiel.sharepoint.com" -Group "Integrantes de la intranet Colaborativa"  -LoginName "s-1-5-21-928925728-1158037820-937652014-33136068"
#Remove-SPOUser -Site "https://prodiel.sharepoint.com" -Group "Integrantes de la intranet Colaborativa"  -LoginName #"josemanuelgonzalez@prodiel.com"#

360c142b-5eca-4f9c-b42c-28192e3d1f58	GS - Proyecto Piloto	Security	Integrantes del proyecto piloto Office 365	
86f9ab16-718a-4d10-9e9f-ac018091622c	GS - Proyecto Office365	Security		
#>