###########################################################################################
# AUTHOR    : José Manuel González - josem@josemanuelgonzalez.net - @jmgonzalez_
# DATE      : 08/02/13
# VERSION   : 1.1
# UPDATE    : 01/03/15
#
# PRE-REQUISITES AND UPDATES --------------------------------------------------------------
# https://technet.microsoft.com/en-us/library/dn568015.aspx
# Remember to setup Set-ExecutionPolicy RemoteSigned, more information: https://technet.microsoft.com/en-us/library/ee176961.aspx 
#
# NOTES -----------------------------------------------------------------------------------
# Custom Filters : https://msdn.microsoft.com/en-us/library/dd264647(v=exchsrvcs.149).aspx
# Members: https://technet.microsoft.com/en-us/library/bb232019(v=exchg.150).aspx
# 
# #########################################################################################






### Import Distribution Groups from csv

#Import CSV
$path     = Split-Path -parent $MyInvocation.MyCommand.Definition 
$path_groups  = $path + "\bulk_distribution_groups.csv"
$csv_groups     = @()
$csv_groups      = Import-Csv -Path $newpath
$path_groups  = $path + "\bulk_groups_members.csv"
$csv_members     = @()
$csv_members      = Import-Csv -Path $newpath


#Loop through all items in the CSV
ForEach ($group In $csv_groups)
{
mpo    New-DistributionGroup -Name $item.name -DisplayName $item.DisplayName -Alias $item.Alias -PrimarySmtpAddress $item.PrimarySmtpAddress
}

###Set distribution groups parameters and members

#add distritubion group owner
Set-DistributionGroup -Identity "<Distribution Group Name>" –ManagedBy <Identity> -BypassSecurityGroupManagerCheck

#Setting Distribution Groups to accept Senders outside of my organization
Set-DistributionGroup "<Distribution Group Name>" -RequireSenderAuthenticationEnabled $False

#Add multiple member without manager approved in a group
ForEach ($member In $csv_members)
{
    Add-DistributionGroupMember -Identity "<Distribution Group Name>" -Member $_.members
}

#Add multiple members to multiple distribution groups
ForEach ($group in $csv_groups)
{
    ForEach ($member In $csv_members)
    {
        Add-DistributionGroupMember -Identity $group.name -Member $member.members
    }
    
}

### Display List of All Dynamics Distribution Groups
Get-DistributionGroup

### All Dynamics Distribution Groups and show DisplayName and PrimarySmtpAddress Columns
Get-DistributionGroup | select DisplayName,PrimarySmtpAddress, emailaddresses

### Display a list of Filter Distrituon groups
Get-DistributionGroup | Where {$_.emailaddresses –like "*prodiel.com"} | FT -Property Name,Alias,EmailAddresses -Autosize


### Returns detailed information about the dynamic distribution
Get-DistributionGroup -Identity "<Distribution Group Name>" | Format-List

### Find and Format information
Get-DistributionGroup *SALAS* | Format-Table Name, ManagedBy -AutoSize
Get-DistributionGroup | select DisplayName,PrimarySmtpAddress,RecipientContainer,Identity,RecipientFilter | Out-GridView

### List all Dynamics Distribution Groups and export to file
Get-DynamicDistributionGroup | select DisplayName,PrimarySmtpAddress,RecipientContainer,Identity,RecipientFilter | Format-Table > groups.txt

### List all Dynamics Distribution Groups and export to csv with some specifications (UTF 8 and comma separated)
Get-DynamicDistributionGroup | select DisplayName,PrimarySmtpAddress,RecipientContainer,Identity,RecipientFilter | Export-Csv -Path "c:\it\out\test.csv" -Encoding UTF8 -Delimiter ","

# Display Members of Distribution Groups
Get-DistributionGroupMember "<Group Name>"



### DYNAMICS DISTRIBUTION GROUPS
#Create a new Dynamics Distribution group with Custom Filter 
New-DynamicDistributionGroup -Name "test_custom_filters" -RecipientFilter {(RecipientType -eq 'UserMailbox') -and (StateOrProvince -eq 'ES')}

#Create Dynamic Distribution Group for all managers
New-DynamicDistributionGroup -Name "<Distribution Group Name>" -RecipientFilter {(RecipientType -eq 'UserMailbox') -and (Title –like <'Title1*'> -or Title -like <'Title2*'>)}

#Create Dynamic Distribution Group for user from specific Office
New-DynamicDistributionGroup -Name "<Distribution Group Name>" -RecipientFilter {(RecipientType -eq 'UserMailbox') -and (Department –like <'Department Name'>)}

# Display Members of Dynamics Distribution Groups
$DDG = Get-DynamicDistributionGroup "test_custom_filters" 
Get-Recipient -RecipientPreviewFilter $DDG.RecipientFilter | FT Alias

