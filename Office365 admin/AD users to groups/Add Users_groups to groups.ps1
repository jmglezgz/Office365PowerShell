########################################################### 
# AUTHOR  : José Manuel González / 
# DATE    : 01/03/15
# EDIT    : 29/09/15
########################################################### 

Import-Module ActiveDirectory

#Import CSV
$path     = Split-Path -parent $MyInvocation.MyCommand.Definition 
#$newpath  = $path + "\bulk_input.csv"
$newpath = "C:\IT_jmglezgz\compras_direccion.CSV"
$csv      = @()
$csv      = Import-Csv -Path $newpath

#Get Domain Base
$searchbase = Get-ADDomain | ForEach {  $_.DistinguishedName }

#Loop through all items in the CSV
Write-Host "State,Group,Member,MemberType,Department"
ForEach ($item In $csv)
{
    Try
    {
        if ($item.MemberSamAccountName -ne ""){
            Add-ADGroupMember -Identity $item.group -Members $item.MembersamAccountName
            Write-Host "SUCCESS,$($item.group),$($item.member),User,$($item.Department)"
        }
        elseif ($item.MemberGroupName -ne ""){
            Add-ADGroupMember -Identity $item.group -Members $item.MemberGroupName
            Write-Host "SUCCESS,$($item.group),$($item.member),Group,$($item.Department)"
        }
        else{
            Write-Host "ERROR,$($item.group),NOT_FOUND,NOT_FOUND,$($item.Department)"
        }
    }
    Catch
    {
        Write-Host "ERROR, $($item.group), $($item.member),,$($item.Department)"
    }


}

