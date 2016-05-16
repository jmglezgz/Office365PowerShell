

#------------------------------------------------------------------------------
# THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT
# WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT
# LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS
# FOR A PARTICULAR PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR 
# RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#
# AUTHOR(s):
#       Eyal Doron (o365info.com)
#------------------------------------------------------------------------------
# Hope that you enjoy it ! 
# And May the force of PowerShell will be with you   :-)
# 20-4-2014    
# Version WP- 001 
#------------------------------------------------------------------------------


Function Disconnect-ExchangeOnline {Get-PSSession | Where-Object {$_.ConfigurationName -eq "MicrosoFT.Exchange"} | Remove-PSSession}
function Validate-UserSelection
{
    Param(
        $AllowedAnswers,
        $ErrorMessage,
        $Selection
    )
    foreach($str in $AllowedAnswers.ToString().Split(","))
    {
        if($str -eq $Selection)
        {
            return $true
        }
    }
    Write-Host $ErrorMessage -ForegroundColor Red -BackgroundColor Black
    return $False

}

function Format-BytesInKiloBytes 
{
    param(
        $bytes
    )
    "{0:N0}" -f ($bytes/1000)
}

Function Set-AlternatingRows {
       <#
       
       #>
    [CmdletBinding()]
       Param(
             [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
        [string]$Line,
       
           [Parameter(Mandatory=$True)]
             [string]$CSSEvenClass,
       
        [Parameter(Mandatory=$True)]
           [string]$CSSOddClass
       )
       Begin {
             $ClassName = $CSSEvenClass
       }
       Process {
             If ($Line.Contains("<tr>"))
             {      $Line = $Line.Replace("<tr>","<tr class=""$ClassName"">")
                    If ($ClassName -eq $CSSEvenClass)
                    {      $ClassName = $CSSOddClass
                    }
                    Else
                    {      $ClassName = $CSSEvenClass
                    }
             }
             Return $Line
       }
}


$FormatEnumerationLimit = -1


#------------------------------------------------------------------------------
# PowerShell console window Style
#------------------------------------------------------------------------------

$pshost = get-host
$pswindow = $pshost.ui.rawui

	$newsize = $pswindow.buffersize
	
	if($newsize.height){
		$newsize.height = 3000
		$newsize.width = 150
		$pswindow.buffersize = $newsize
	}

	$newsize = $pswindow.windowsize
	if($newsize.height){
		$newsize.height = 50
		$newsize.width = 150
		$pswindow.windowsize = $newsize
	}

#------------------------------------------------------------------------------
# HTML Style start 
#------------------------------------------------------------------------------
$Header = @"
<style>
Body{font-family:segoe ui,arial;color:black; }
H1{ color: white; background-color:#1F4E79; font-weight:bold;width: 70%;margin-top:35px;margin-bottom:25px;font-size: 22px;padding:5px 15px 5px 10px; }
TABLE {border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
TH {border-width: 1px;padding: 5px;border-style: solid;border-color: #d1d3d4;background-color:#0072c6 ;color:white;}
TD {border-width: 1px;padding: 3px;border-style: solid;border-color: black;}
.odd  { background-color:#ffffff; }
.even { background-color:#dddddd; }
</style>

"@

#------------------------------------------------------------------------------
# HTML Style END
#------------------------------------------------------------------------------



$Loop = $true
While ($Loop)
{
    write-host 
    write-host ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    write-host   Distribution Groups  | PowerShell Script menu  
    write-host ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    write-host
    write-host -ForegroundColor green  'Connect PowerShell session to AD Azure and Exchange Online' 
    write-host -ForegroundColor green  '--------------------------------------------------------------' 
    write-host -ForegroundColor Yellow ' 0)   Login in using your Office 365 Administrator credentials' 
    write-host
    write-host -ForegroundColor green  '---------------------------' 
    write-host -ForegroundColor white  -BackgroundColor Blue 'Section A: Mange Distribution Groups ' 
    write-host -ForegroundColor green  '---------------------------' 
    write-host
    write-host                                              ' 1)   Add user to a Distribution Group'
	write-host                                              ' 2)   Setting Distribution Groups to accept Senders outside of my organization'
	write-host                                              ' 3)   Adding Distribution Group owner'
	write-host                                              ' 4)   Set a specific user as owner of all Office 365 (BULK Mode)'
	write-host                                              ' 5)   Add an e-mail alias to Distribution group'
	write-host                                              ' 6)   Assign Send As Permissions to Distribution Group'
	write-host                                              ' 7)   Delete Distribution Group'
	write-host 
		
    write-host -ForegroundColor green  '---------------------------' 
    write-host -ForegroundColor white  -BackgroundColor Blue 'Section B: Mange Dynamic Distribution Group  ' 
    write-host -ForegroundColor green  '---------------------------' 
    write-host
   write-host                                              	' 8)  Create Dynamic Distribution list for all Office 365 users'
	write-host                                              ' 9)  Create Dynamic Distribution list for user from specific Office'
	write-host                                              ' 10) Create Dynamic Distribution list for For all managers'
	
	
	
	write-host -ForegroundColor green  '---------------------------' 
    write-host -ForegroundColor white  -BackgroundColor Blue 'Section C: Display Information about Distribution Group  ' 
    write-host -ForegroundColor green  '---------------------------' 
    write-host
    write-host                                              ' 11)   Display list of Distribution Groups'
	write-host                                              ' 12)   Display Distribution Group Members'
	write-host                                              ' 13)   Display members of Dynamic Distribution Group'
	write-host 
	
	
	write-host -ForegroundColor green  '---------------------------' 
    write-host -ForegroundColor white  -BackgroundColor Blue ' Section D: Import and Export  ' 
    write-host -ForegroundColor green  '---------------------------' 
    write-host
    write-host                                             ' 14)   Import group members to a Distribution Group'
	write-host                                              '15)   Create bulk Distribution Groups '
	
	
	write-host -ForegroundColor green  '---------------------------' 
    write-host -ForegroundColor Blue  -BackgroundColor Yello ' Exit\Disconnect ' 
    write-host -ForegroundColor green  '---------------------------' 
    write-host
    write-host  -ForegroundColor Yellow                       ' 16)  Disconnect PowerShell session'
	write-host 
	write-host  -ForegroundColor Yellow                       ' 17)  Exit'
	write-host 
	write-host                                          

	

    $opt = Read-Host "Select an option [0-17]"
    write-host $opt
    switch ($opt) 


{


		#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		# Step -00 |  Create a Remote PowerShell session to AD Azure and Exchange Online
		#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


		0
        {

            # Specify your administrative user credentials on the line below 

            $user = “Admin@.....”

            # This will pop-up a dialogue and request your password
            

            #——– Import the Local Microsoft Online PowerShell Module Cmdlets and  Establish an Remote PowerShell Session to AD Azure  
            
            Import-Module MSOnline

            

            #———— Establish an Remote PowerShell Session to Exchange Online ———————

            $msoExchangeURL = “https://outlook.office365.com/powershell-liveid/”
			$connected = $false
			$i = 0
			while ( -not ($connected)) {
				$i++
				if($i -eq 4){
					
										
					Write-host
					Write-host -ForegroundColor White	ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
					Write-host
					Write-host -ForegroundColor Red    "Too many incorrect login attempts. Good bye."	
					Write-host
					Write-host -ForegroundColor White	ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
					Write-host
					
					
					exit
				}
				$cred = Get-Credential -Credential $user
				try 
				{
					$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $msoExchangeURL -Credential $cred -Authentication Basic -AllowRedirection  -ErrorAction stop
					Connect-MsolService -Credential $cred -ErrorAction stop
					Import-PSSession $session 
					$connected = $true 
				}
				catch 
				{
					Write-host
					Write-host -ForegroundColor Yellow	ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
					Write-host
					Write-host -ForegroundColor Red     "There is something wrong with the global administrator credentials"	
					Write-host
					Write-host -ForegroundColor Yellow	ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
					Write-host
				}

			}
            
			$host.ui.RawUI.WindowTitle = ("Windows Azure Active Directory |Connected to Office 365 using: " + $Cred.UserName.ToString()  ) 

            


        }





		
		#+++++++++++++++++++++++++++++++++++++++++++++++++
		# Section A: Mange Distribution Groups
		#+++++++++++++++++++++++++++++++++++++++++++++++++

		1
		{

			#####################################################################
			# Add user to a Distribution Group
			#####################################################################

			# Section 1: information 

				clear-host
				write-host
				write-host
				write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                            
				write-host  -ForegroundColor white		Introduction                                                                                          
				write-host  -ForegroundColor white		--------------------------------------------------------------------------------------                                                              
				write-host  -ForegroundColor white  	'In the following section we will: '
				write-host  -ForegroundColor white  	'Add user to a Distribution Group'
				write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                          
				write-host  -ForegroundColor white  	'The PowerShell command that we use is: '
				write-host  -ForegroundColor Yellow  	'Add-DistributionGroupMember -<Distribution Group> -Member <User>  -BypassSecurityGroupManagerCheck'
				write-host  -ForegroundColor white		----------------------------------------------------------------------------  	
				
													
					# Section 2: user input	
					
					write-host -ForegroundColor white	'User input '
					write-host -ForegroundColor white	---------------------------------------------------------------------------- 
					write-host -ForegroundColor Yellow	"You will need to provide 2 parameters:"  
					write-host
					write-host -ForegroundColor Yellow	"1. Distribution Group name  "  
					write-host -ForegroundColor Yellow	"For example:  DL-USA"
					write-host
					$DL  = Read-Host "Type the Distribution Group name "
					write-host
					write-host
					write-host -ForegroundColor Yellow	"2. User name   "  
					write-host -ForegroundColor Yellow	"For example:  Alice@contoso.com "
					
					$UserName   = Read-Host "Type the user name "
					write-host
				
										
					# Section 3: PowerShell Command

					Add-DistributionGroupMember -Identity $DL -Member $UserName  -BypassSecurityGroupManagerCheck

					# Section 4:  Indication 

					write-host
					write-host 

								if ($lastexitcode -eq 1)
								{
									write-host "The command Failed :-(" -ForegroundColor red
								}
								else
								{
									write-host -------------------------------------------------------------
									write-host -ForegroundColor Yellow	"The command complete successfully !"           
									write-host -------------------------------------------------------------
									
								}

										
					#———— End of Indication ———————



					#Section 5: End the Command
					write-host
					write-host
					Read-Host "Press Enter to continue..."
					write-host
					write-host

		}





		2
		{

		####################################################################################################
		# Setting Distribution Groups to accept Senders outside of my organization
		#####################################################################################################

		# Section 1: information

				clear-host
				write-host
				write-host
				write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                            
				write-host  -ForegroundColor white		Introduction                                                                                          
				write-host  -ForegroundColor white		--------------------------------------------------------------------------------------                                                              
				write-host  -ForegroundColor white  	'In the following section we will: '
				write-host  -ForegroundColor white  	'Set Distribution Groups to: Senders inside and outside of my organization'
				write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                          
				write-host  -ForegroundColor white  	'The PowerShell command that we use is: '
				write-host  -ForegroundColor Yellow  	'Set-DistributionGroup -Identity <Distribution Group> -RequireSenderAuthenticationEnabled $False '
				write-host  -ForegroundColor white		----------------------------------------------------------------------------  	



					
		# Section 2: user input	
					
					write-host -ForegroundColor white	'User input '
					write-host -ForegroundColor white	---------------------------------------------------------------------------- 
					write-host -ForegroundColor Yellow	"You will need to provide 1 parameter:"  
					write-host
					write-host -ForegroundColor Yellow	"1. Distribution Group name  "  
					write-host -ForegroundColor Yellow	"For example:  DL-USA"
					write-host
					$DL  = Read-Host "Type the Distribution Group name "
					write-host
					
		
				
				# Section 3: PowerShell Command

				Set-DistributionGroup -Identity $DL -RequireSenderAuthenticationEnabled $False


				# Section 4:  Indication 
				write-host 
				if ($lastexitcode -eq 1)
				{
					write-host "The command Failed :-(" -ForegroundColor red
				}
				else

				{
					
					
					write-host -------------------------------------------------------------
					write-host -ForegroundColor Yellow	"The command complete successfully !"           
					      
					write-host -------------------------------------------------------------
					
				}

				#———— End of Indication ———————



				#Section 5: End the Command
				write-host
				write-host
				Read-Host "Press Enter to continue..."
				write-host
				write-host



		}





		3
		{


				#####################################################################
				#  Adding Distribution Group Owner
				#####################################################################

				# Section 1: information 

				# Section 1: information

				clear-host
				write-host
				write-host
				write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                            
				write-host  -ForegroundColor white		Introduction                                                                                          
				write-host  -ForegroundColor white		--------------------------------------------------------------------------------------                                                              
				write-host  -ForegroundColor white  	'In the following section we will: '
				write-host  -ForegroundColor white  	'Set Distribution Groups owner'
				write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                          
				write-host  -ForegroundColor white  	'The PowerShell command that we use is: '
				write-host  -ForegroundColor Yellow  	'	Set-DistributionGroup -Identity "<Distribution Group>" -ManagedBy <User>  -BypassSecurityGroupManagerCheck '
				write-host  -ForegroundColor white		----------------------------------------------------------------------------  	


				
				
				# Section 2: user input	
					
					write-host -ForegroundColor white	'User input '
					write-host -ForegroundColor white	---------------------------------------------------------------------------- 
					write-host -ForegroundColor Yellow	"You will need to provide 2 parameters:"  
					write-host
					write-host -ForegroundColor Yellow	"1. Distribution Group name  "  
					write-host -ForegroundColor Yellow	"For example:  DL-USA"
					write-host
					$DL  = Read-Host "Type the Distribution Group name "
					write-host
					write-host
					write-host -ForegroundColor Yellow	"2. User name   "  
					write-host -ForegroundColor Yellow	"For example:  Alice@contoso.com "
					
					$UserName   = Read-Host "Type the user name "
					write-host


				# Section 3: PowerShell Command


				 Set-DistributionGroup -Identity "$DL" -ManagedBy $UserName  -BypassSecurityGroupManagerCheck

				# Section 5:  Indication 


				write-host 
				if ($lastexitcode -eq 1)
				{
					write-host "The command Failed :-(" -ForegroundColor red
				}
				else
				{
						
					write-host -------------------------------------------------------------
					write-host -ForegroundColor Yellow	"The command complete successfully !" 
					write-host
					write-host -ForegroundColor Yellow	"The user:  "
					write-host -ForegroundColor White	$UserName.ToUpper() 
					write-host -ForegroundColor Yellow	"is the owner of  "	
					write-host -ForegroundColor white	$DL
					write-host -ForegroundColor Yellow	"Distribution Group"	
					write-host -------------------------------------------------------------
					
				}

				#———— End of Indication ———————

				#Section 5: End the Command
				write-host
				write-host
				Read-Host "Press Enter to continue..."
				write-host
				write-host

		}





		4
		{

				####################################################################################################
				# Set a specific user as owner of all Office 365 (BULK Mode)
				######################################################################################################


				# Section 1: information

				
				clear-host
				write-host
				write-host
				write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                            
				write-host  -ForegroundColor white		Introduction                                                                                          
				write-host  -ForegroundColor white		--------------------------------------------------------------------------------------                                                              
				write-host  -ForegroundColor white  	'In the following section we will: '
				write-host  -ForegroundColor white  	'Set a specific user as owner of all Office 365 (BULK Mode)'
				write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                          
				write-host  -ForegroundColor white  	'The PowerShell command that we use is: '
				write-host  -ForegroundColor Yellow  	'Get-DistributionGroup |Set-DistributionGroup -ManagedBy <user> –BypassSecurityGroupManagerCheck '
				write-host  -ForegroundColor white		----------------------------------------------------------------------------  	

				
				

							
				# Section 2: user input	
					
					write-host -ForegroundColor white	'User input '
					write-host -ForegroundColor white	---------------------------------------------------------------------------- 
					write-host -ForegroundColor Yellow	"You will need to provide 1 parameter:"  
					write-host
					write-host -ForegroundColor Yellow	"1. User name   "  
					write-host -ForegroundColor Yellow	"For example:  Alice@contoso.com "
					
					$UserName   = Read-Host "Type the user name "
					write-host

				
				
				

				# Section 3: PowerShell Command


				Get-DistributionGroup |Set-DistributionGroup -ManagedBy “$UserName” –BypassSecurityGroupManagerCheck


				# Section 4:  Indication 
				write-host 
				if ($lastexitcode -eq 0)
				{
					write-host -------------------------------------------------------------
					write-host -ForegroundColor Yellow	"The command complete successfully !"           
					
					write-host -------------------------------------------------------------
				}
				else

				{
					write-host "The command Failed :-(" -ForegroundColor red
					
				}

				#———— End of Indication ———————



				#Section 5: End the Command
				write-host
				write-host
				Read-Host "Press Enter to continue..."
				write-host
				write-host

		}



		5
		{

		####################################################################################################
		# Add an e-mail Alias to Distribution group
		######################################################################################################


		
		# Section 1: information

				
				clear-host
				write-host
				write-host
				write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                            
				write-host  -ForegroundColor white		Introduction                                                                                          
				write-host  -ForegroundColor white		--------------------------------------------------------------------------------------                                                              
				write-host  -ForegroundColor white  	'In the following section we will: '
				write-host  -ForegroundColor white  	'Add an e-mail Alias to Distribution group'
				write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                          
				write-host  -ForegroundColor white  	'The PowerShell command that we use is: '
				write-host  -ForegroundColor Yellow  	'Set-DistributionGroup "<Distribution Group>" -EmailAddresses SMTP:<Primary email address>,<Alias email address>'
				write-host  -ForegroundColor white		----------------------------------------------------------------------------  	

				
				
				
				# Section 2: user input	
					
					write-host -ForegroundColor white	'User input '
					write-host -ForegroundColor white	---------------------------------------------------------------------------- 
					write-host -ForegroundColor Yellow	"You will need to provide 3 parameters:"  
					write-host
					write-host -ForegroundColor Yellow	"1. Distribution Group name  "  
					write-host -ForegroundColor Yellow	"For example:  DL-USA"
					write-host
					$DL  = Read-Host "Type the Distribution Group name "
					write-host
					write-host
					write-host -ForegroundColor Yellow	"2. Distribution Group Primary Email address   "  
					write-host -ForegroundColor Yellow	"For example:  Dl-USA-Users@o365info.com "
					$PriEmail   = Read-Host "Type the Primary Email address "
					write-host
					write-host
					write-host -ForegroundColor Yellow	"3. Distribution Group Alias Email address   "  
					write-host -ForegroundColor Yellow	"For example:  info@o365info.com "
					$PriEmail   = Read-Host "Type the Alias Email address "
					write-host

		


					# Section 3: PowerShell Command


					Set-DistributionGroup "$DL" -EmailAddresses SMTP:$PriEmail,$AliasEmail


					# Section 4:  Indication 
					write-host 
					if ($lastexitcode -eq 0)
					{
						write-host -------------------------------------------------------------
						write-host -ForegroundColor Yellow	"The command complete successfully !"           
					
						write-host -------------------------------------------------------------
					}
					else

					{
						write-host "The command Failed :-(" -ForegroundColor red
						
					}

					#———— End of Indication ———————



					#Section 5: End the Command
					write-host
					write-host
					Read-Host "Press Enter to continue..."
					write-host
					write-host

		}



		6
		{

			####################################################################################################
			# Assign Send As Permissions to Distribution Group 
			######################################################################################################


			
			
			# Section 1: information

				
				clear-host
				write-host
				write-host
				write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                            
				write-host  -ForegroundColor white		Introduction                                                                                          
				write-host  -ForegroundColor white		--------------------------------------------------------------------------------------                                                              
				write-host  -ForegroundColor white  	'In the following section we will: '
				write-host  -ForegroundColor white  	' Assign Send As Permissions to Distribution Group '
				write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                          
				write-host  -ForegroundColor white  	'The PowerShell command that we use is: '
				write-host  -ForegroundColor Yellow  	'Add-RecipientPermission $DL -Trustee <User Name> -AccessRights SendAs -Confirm:$False'
				write-host  -ForegroundColor white		----------------------------------------------------------------------------  	

				
				
				
				# Section 2: user input	
					
				
					write-host -ForegroundColor white	'User input '
					write-host -ForegroundColor white	---------------------------------------------------------------------------- 
					write-host -ForegroundColor Yellow	"You will need to provide 2 parameters:"  
					write-host
					write-host -ForegroundColor Yellow	"1. Distribution Group name  "  
					write-host -ForegroundColor Yellow	"For example:  DL-USA"
					write-host
					$DL  = Read-Host "Type the Distribution Group name "
					write-host
					write-host
					write-host -ForegroundColor Yellow	"2. User name   "  
					write-host -ForegroundColor Yellow	"For example:  Alice@contoso.com "
					
					$UserName   = Read-Host "Type the user name "
					write-host
			
			
			
			


						# Section 3: PowerShell Command

						Add-RecipientPermission $DL -Trustee $UserName -AccessRights SendAs -Confirm:$False



						# Section 4:  Indication 
						write-host 
						write-host



							if ($lastexitcode -eq 1)
							{
								
							write-host "The command Failed :-(" -ForegroundColor red	
								
							}
							else

							{
								
								
								write-host -------------------------------------------------------------
								write-host -ForegroundColor Yellow "The command complete successfully !"           
								                     	
								write-host -------------------------------------------------------------
								
								
								
							}

							#———— End of Indication ———————


							#Section 5: End the Command
							write-host
							write-host
							Read-Host "Press Enter to continue..."
							write-host
							write-host


	}






	7
	{

	####################################################################################################
	# Delete Distribution Group
	######################################################################################################


	

	# Section 1: information

				
				clear-host
				write-host
				write-host
				write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                            
				write-host  -ForegroundColor white		Introduction                                                                                          
				write-host  -ForegroundColor white		--------------------------------------------------------------------------------------                                                              
				write-host  -ForegroundColor white  	'In the following section we will: '
				write-host  -ForegroundColor white  	' Delete Distribution Group '
				write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                          
				write-host  -ForegroundColor white  	'The PowerShell command that we use is: '
				write-host  -ForegroundColor Yellow  	'Remove-DistributionGroup -Identity <Distribution Group> -BypassSecurityGroupManagerCheck'
				write-host  -ForegroundColor white		----------------------------------------------------------------------------  	
				
								
				# Section 2: user input	
					
				
				write-host -ForegroundColor white	'User input '
					write-host -ForegroundColor white	---------------------------------------------------------------------------- 
					write-host -ForegroundColor Yellow	"You will need to provide 1 parameter:"  
					write-host
					write-host -ForegroundColor Yellow	"1. Distribution Group name  "  
					write-host -ForegroundColor Yellow	"For example:  DL-USA"
					write-host
					$DL  = Read-Host "Type the Distribution Group name "
					write-host
					
			


					# Section 3: PowerShell Command

					Remove-DistributionGroup -Identity $DL -BypassSecurityGroupManagerCheck



					# Section 4:  Indication 
					write-host 
					write-host



					if ($lastexitcode -eq 1)
					{
						
					write-host "The command Failed :-(" -ForegroundColor red	
						
					}
					else

					{
						
						
						write-host -------------------------------------------------------------
						write-host -ForegroundColor Yellow "The command complete successfully !"           
						write-host -ForegroundColor Yellow "The following Distribution Group: "    
						write-host -ForegroundColor White  "$DL"                                
						write-host -ForegroundColor Yellow "Was successfully deleted "                 
						write-host -------------------------------------------------------------
						
						
						
					}

					#———— End of Indication ———————


					#Section 5: End the Command
					write-host
					write-host
					Read-Host "Press Enter to continue..."
					write-host
					write-host


	}

















#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# Section B: Mange Dynamic Distribution Group
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



	8
	{

	####################################################################################################
	# Create Dynamic Distribution Group for all Office 365 users
	######################################################################################################


	# Section 1: information

	clear-host
	   
				write-host
				write-host  -ForegroundColor Magenta	ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                        
				write-host  -ForegroundColor white		Information                                                                                           
				write-host  -ForegroundColor white		--------------------------------------------------------------------                                                           
				write-host  -ForegroundColor white  	"This option will:"  
				write-host  -ForegroundColor white  	"Create Dynamic Distribution list for all Office 365 users that have mailbox"
				write-host  -ForegroundColor white  	"*general information: verse standard Distribution list," 
				write-host  -ForegroundColor white  	"The membership in Dynamic Distribution list cannot"    
				write-host  -ForegroundColor white  	"be displayed by expanding the Distribution list name"
				write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                          
				write-host  -ForegroundColor white  	'The PowerShell command that we use is: '
				write-host  -ForegroundColor Yellow  	'New-DynamicDistributionGroup -Name <Distribution Group>  -RecipientFilter { (RecipientType -eq 'UserMailbox')  }'
				write-host  -ForegroundColor white		----------------------------------------------------------------------------  	                                  
				write-host
				write-host

				
					write-host -ForegroundColor white	'User input '
					write-host -ForegroundColor white	---------------------------------------------------------------------------- 
					write-host -ForegroundColor Yellow	"You will need to provide 1 parameter:"  
					write-host
					write-host -ForegroundColor Yellow	"1. Distribution Group name  "  
					write-host -ForegroundColor Yellow	"For example:  DL-USA"
					write-host
					$DL  = Read-Host "Type the Distribution Group name "
					write-host
					
									
								# Section 3: PowerShell Command

								New-DynamicDistributionGroup -Name $DL  -RecipientFilter { (RecipientType -eq 'UserMailbox')  }

								write-host


								# Section 4:  Indication 


								write-host 
								if ($lastexitcode -eq 0)
								{
									write-host -------------------------------------------------------------
									write-host -ForegroundColor Yellow	"The command complete successfully !"           
									
									write-host -------------------------------------------------------------
								}
								else

								{
									write-host "The command Failed :-(" -ForegroundColor red
									
								}

								#———— End of Indication ———————



								#Section 5: End the Command
								write-host
								write-host
								Read-Host "Press Enter to continue..."
								write-host
								write-host




	}


	9
	{

		####################################################################################################
		# Create Dynamic Distribution Group for user from specific Office 
		######################################################################################################

		# Section 1: information

		clear-host
		   
		write-host
			write-host  -ForegroundColor Magenta	ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                        
			write-host  -ForegroundColor white		Information                                                                                           
			write-host  -ForegroundColor white		--------------------------------------------------------------------                                                           
			write-host  -ForegroundColor white  	"This option will:"  
			write-host  -ForegroundColor white  	"Create Dynamic Distribution list for user from specific Office "
			write-host  -ForegroundColor white  	"For example users that belong to NY Office "
			write-host  -ForegroundColor white  	"*general information: verse standard Distribution list," 
			write-host  -ForegroundColor white  	"The membership in Dynamic Distribution list cannot"    
			write-host  -ForegroundColor white  	"be displayed by expanding the Distribution list name"
			write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                          
			write-host  -ForegroundColor white  	'The PowerShell command that we use is: '
			write-host  -ForegroundColor Yellow  	'New-DynamicDistributionGroup -Name "<Distribution Group>" -RecipientFilter {(RecipientType -eq 'UserMailbox')  -and (Department -like '$Office')}'
			write-host  -ForegroundColor white		----------------------------------------------------------------------------  	                                  
			write-host
			write-host                                       
			write-host
			write-host

		
					write-host -ForegroundColor white	'User input '
					write-host -ForegroundColor white	---------------------------------------------------------------------------- 
					write-host -ForegroundColor Yellow	"You will need to provide 2 parameters:"  
					write-host
					write-host -ForegroundColor Yellow	"1. Distribution Group name  "  
					write-host -ForegroundColor Yellow	"For example:  ALL-Office365-users"
					write-host
					$DL  = Read-Host "Type the Distribution Group name "
					write-host
					write-host
					write-host -ForegroundColor Yellow	"2. Office name   "  
					write-host -ForegroundColor Yellow	"For example:  NY "
					
					$UserName   = Read-Host "Type the Office name "
					write-host
			
		

						# Section 3: PowerShell Command	
							
						New-DynamicDistributionGroup -Name "$DL" -RecipientFilter {(RecipientType -eq 'UserMailbox')  -and (Department -like '$Office')}


						write-host


						# Section 4:  Indication 


						write-host 
						if ($lastexitcode -eq 0)
						{
							write-host -------------------------------------------------------------
							write-host -ForegroundColor Yellow	"The command complete successfully !"           
											
							write-host -------------------------------------------------------------
						}
						else

						{
							write-host "The command Failed :-(" -ForegroundColor red
							
						}

						#———— End of Indication ———————



						#Section 5: End the Command
						write-host
						write-host
						Read-Host "Press Enter to continue..."
						write-host
						write-host




	}

	10
	{

					####################################################################################################
					#  Create Dynamic Distribution Group for all managers 
					######################################################################################################


					# Section 1: information


					clear-host
					   
						write-host
						write-host  -ForegroundColor Magenta	ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                        
						write-host  -ForegroundColor white		Information                                                                                           
						write-host  -ForegroundColor white		--------------------------------------------------------------------                                                           
						write-host  -ForegroundColor white  	"This option will:"  
						write-host  -ForegroundColor white  	"Create Dynamic Distribution Group for all managers  "
						write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                          
						write-host  -ForegroundColor white  	'The PowerShell command that we use is: '
						write-host  -ForegroundColor Yellow  	'New-DynamicDistributionGroup -Name "<Distribution Group>" -RecipientFilter {(RecipientType -eq 'UserMailbox') -and (Title -like 'Director*' -or Title -like 'Manager*')} '
						write-host  -ForegroundColor white		----------------------------------------------------------------------------  	                                  
						write-host
						write-host                                       

					# Section 2: user input
						
					
					rite-host -ForegroundColor white	'User input '
					write-host -ForegroundColor white	---------------------------------------------------------------------------- 
					write-host -ForegroundColor Yellow	"You will need to provide 1 parameter:"  
					write-host
					write-host -ForegroundColor Yellow	"1. Distribution Group name  "  
					write-host -ForegroundColor Yellow	"For example:  organisation managers"
					write-host
					$DL  = Read-Host "Type the Distribution Group name "
					write-host
					write-host
					
					write-host
					
					

					# Section 3: PowerShell Command
						
					New-DynamicDistributionGroup -Name "$DL " -RecipientFilter {(RecipientType -eq 'UserMailbox') -and (Title -like 'Director*' -or Title -like 'Manager*')} 


					write-host

					# Section 4:  Indication 


					write-host 
					if ($lastexitcode -eq 0)
					{
						write-host -------------------------------------------------------------
						write-host -ForegroundColor Yellow	"The command complete successfully !"           
						                
						write-host -------------------------------------------------------------
					}
					else

					{
						write-host "The command Failed :-(" -ForegroundColor red
						
					}

					#———— End of Indication ———————



					#Section 5: End the Command
					write-host
					write-host
					Read-Host "Press Enter to continue..."
					write-host
					write-host



	}





#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# Section C: Display Information about Distribution Group
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<




	11
	{

			####################################################################################################
			# Display list of Distribution Groups 
			######################################################################################################



			# Section 1: information

			clear-host
			   
			write-host
			write-host  -ForegroundColor Magenta	ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                        
			write-host  -ForegroundColor white		Information                                                                                          
			write-host  -ForegroundColor white		--------------------------------------------------------------------                                                           
			write-host  -ForegroundColor white  	"This option will:"  
			write-host  -ForegroundColor white  	"Display list of Distribution Groups "
			write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                          
			write-host  -ForegroundColor white  	'The PowerShell command that we use is: '
			write-host  -ForegroundColor Yellow  	'Get-DistributionGroup  '
			
			write-host  -ForegroundColor white		----------------------------------------------------------------------------  	                                  
			write-host
			write-host              


				
				
			# Section 2: PowerShell Command


			write-host ------------------------------------------------------
			write-host List of Distribution Groups    -ForegroundColor Yellow
			write-host -------------------------------------------------------
			Get-DistributionGroup  | Out-String


			#Section 3: End the Command
			write-host
			write-host
			Read-Host "Press Enter to continue..."
			write-host
			write-host


		}




	12
	{

			####################################################################################################
			# Display Distribution Group Members
			#####################################################################################################



			clear-host
			   
			write-host
			write-host  -ForegroundColor Magenta	ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                        
			write-host  -ForegroundColor white		Information                                                                                           
			write-host  -ForegroundColor white		--------------------------------------------------------------------                                                           
			write-host  -ForegroundColor white  	"This option will:"  
			write-host  -ForegroundColor white  	"Display Distribution Group Members "
			write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                          
			write-host  -ForegroundColor white  	'The PowerShell command that we use is: '
			write-host  -ForegroundColor Yellow  	'Get-DistributionGroupMember "<Distribution Group>"  '
			write-host  -ForegroundColor white		----------------------------------------------------------------------------  	                                  
			write-host
			write-host              

			write-host -ForegroundColor Yellow	"You will need to Provide 1 parameters:"  
			write-host
			write-host -ForegroundColor Yellow	"1) The parameter is the Distribution Group name"  
			write-host -ForegroundColor Yellow	"For example: DL-USA"
			write-host
			$DL = Read-Host "Type the Distribution Group name "
			write-host	

			write-host
			write-host
			write-host ------------------------------------------------------
			write-host -ForegroundColor Yellow list of $DL Distribution Group Members
			write-host -------------------------------------------------------

			Get-DistributionGroupMember $DL | Out-String

			write-host
			write-host -------------------------------------------------------
			write-host
			write-host


			write-host
			write-host
			Read-Host "Press Enter to continue..."
			write-host
			write-host



	}



	13
	{

		####################################################################################################
		# Display members of Dynamic Distribution Group
		######################################################################################################



		# Section 1: information

		clear-host
		   
		write-host
		write-host  -ForegroundColor Magenta	ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                        
		write-host  -ForegroundColor white		Information                                                                                          
		write-host  -ForegroundColor white		--------------------------------------------------------------------                                                           
		write-host  -ForegroundColor white  	"This option will:"  
		write-host  -ForegroundColor white  	"Display the members of a Dynamic Distribution Groups "
		write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                          
		write-host  -ForegroundColor white  	'The PowerShell command that we use is: '
		write-host  -ForegroundColor Yellow  	'$DDG = Get-DynamicDistributionGroup $DDL  '
		write-host  -ForegroundColor Yellow  	'Get-Recipient -RecipientPreviewFilter $DDG.RecipientFilter |FT Alias  '
		write-host  -ForegroundColor white		----------------------------------------------------------------------------  	                                  
		write-host
		write-host              

		# Section 2: user input
			
		write-host -ForegroundColor Yellow	" provide the Dynamic Distribution Group name:"  
		write-host
		write-host 
		write-host
		$DDL = Read-Host "Type the Dynamic Distribution Groups name "
		write-host	
			
			
		# Section 3: PowerShell Command


		write-host ------------------------------------------------------
		write-host List of $dlname Dynamic Distribution Groups members   -ForegroundColor Yellow
		write-host -------------------------------------------------------
		$DDG = Get-DynamicDistributionGroup $DDL
		Get-Recipient -RecipientPreviewFilter $DDG.RecipientFilter |FT Alias | Out-String



		#Section 5: End the Command
		write-host
		write-host
		Read-Host "Press Enter to continue..."
		write-host
		write-host



	}


	



#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# Section D: Import and Export
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



	14
	{

	####################################################################################################
	# Import group members to a Distribution group by using CSV file 
	######################################################################################################



           # Section 1: information

			clear-host
   
			write-host
			write-host  -ForegroundColor Magenta	ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                        
			write-host  -ForegroundColor white		Information                                                                                          
			write-host  -ForegroundColor white		--------------------------------------------------------------------                                                           
			write-host  -ForegroundColor white  	"This option will:"  
			write-host  -ForegroundColor white  	"Import group members to a Distribution group by using CSV file "
			write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                          
			write-host  -ForegroundColor white  	'The PowerShell command that we use is: '
			write-host  -ForegroundColor Yellow  	'Import-CSV "<Path>"  | ForEach {Add-DistributionGroupMember -Identity "<Distribution Group>" -Member $_.identity}  '
			
			write-host  -ForegroundColor white		----------------------------------------------------------------------------  	                                  
			write-host
			write-host              
			
					write-host -ForegroundColor white	'User input '
					write-host -ForegroundColor white	---------------------------------------------------------------------------- 
					write-host -ForegroundColor Yellow	"You will need to provide 2 parameters:"  
					write-host
					write-host -ForegroundColor Yellow	"1. Distribution Group name  "  
					write-host -ForegroundColor Yellow	"For example:  ALL-Office365-users"
					write-host
					$DL  = Read-Host "Type the Distribution Group name "
					write-host
					write-host
					write-host -ForegroundColor Yellow	"2. The full Path of the CSV File   "  
					write-host -ForegroundColor Yellow	"For example: C:\Temp\Users.csv "
					
					$Path   = Read-Host "Type the Path name "
					write-host
					
						
					# Section 3: PowerShell Command


					Import-Csv "$Path"  | ForEach {Add-DistributionGroupMember -Identity "$DL" -Member $_.identity}




					# Section 4:  Indication 

					write-host
					write-host

					if ($lastexitcode -eq 1)
					{
						write-host "The command Failed :-(" -ForegroundColor red
					}
					else
					{
					write-host -------------------------------------------------------------
					write-host -ForegroundColor Yellow	"The command complete successfully !" 
					write-host -------------------------------------------------------------
					}

					#———— End of Indication ———————

					# Section 4: Display Information



					#Section 3: End the Command
					write-host
					write-host
					Read-Host "Press Enter to continue..."
					write-host
					write-host


		}







	15
	{

			####################################################################################################
			# Create bulk Distribution Groups 
			######################################################################################################



			# Section 1: information

			clear-host
			   
			write-host
			write-host  -ForegroundColor Magenta	ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                        
			write-host  -ForegroundColor white		Information                                                                                          
			write-host  -ForegroundColor white		--------------------------------------------------------------------                                                           
			write-host  -ForegroundColor white  	"This option will:"  
			write-host  -ForegroundColor white  	" Create bulk Distribution Groups by using CSV file "
			write-host  -ForegroundColor Magenta	oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo                                          
			write-host  -ForegroundColor white  	'The PowerShell command that we use is: '
			write-host  -ForegroundColor Yellow  	'	Import-CSV "<Path>" | ForEach {New-DistributionGroup -Name $_.name -Type $_.Type}  '
			write-host  -ForegroundColor white		----------------------------------------------------------------------------  	                                  
			write-host
			write-host              


			# Section 2: user input

					Write-host -ForegroundColor white	'User input '
					write-host -ForegroundColor white	---------------------------------------------------------------------------- 
					write-host -ForegroundColor Yellow	"You will need to provide 1 parameter:"  
					
					write-host -ForegroundColor Yellow	"1. The full Path of the CSV File   "  
					write-host -ForegroundColor Yellow	"For example: C:\Temp\Groups.csv "
					
					$Path   = Read-Host "Type the Path name "
					write-host

				
				
			# Section 3: PowerShell Command




							Import-CSV "$Path" | ForEach {New-DistributionGroup -Name $_.name -Type $_.Type}




							# Section 4:  Indication 

							write-host
							write-host

							if ($lastexitcode -eq 1)
							{
								write-host "The command Failed :-(" -ForegroundColor red
							}
							else
							{
							write-host -------------------------------------------------------------
							write-host -ForegroundColor Yellow	"The command complete successfully !" 
							write-host -------------------------------------------------------------
							}

							#———— End of Indication ———————

							# Section 4: Display Information



							#Section 3: End the Command
							write-host
							write-host
							Read-Host "Press Enter to continue..."
							write-host
							write-host


			}







						
				 
				#+++++++++++++++++++
				# Step -05 Finish  
				##++++++++++++++++++
				 
				 
				16{

				##########################################
				# Disconnect PowerShell session  
				##########################################


				write-host -ForegroundColor Yellow Choosing this option will Disconnect the current PowerShell session 

				Function Disconnect-ExchangeOnline {Get-PSSession | Where-Object {$_.ConfigurationName -eq "MicrosoFT.Exchange"} | Remove-PSSession}
				Disconnect-ExchangeOnline -confirm

				write-host
				write-host

				#———— Indication ———————

				if ($lastexitcode -eq 0)
				{
					write-host -------------------------------------------------------------
					write-host "The command complete successfully !" -ForegroundColor Yellow
					write-host "The PowerShell session is disconnected" -ForegroundColor Yellow
					write-host -------------------------------------------------------------
				}
				else

				{
					write-host "The command Failed :-(" -ForegroundColor red
					
				}

				#———— End of Indication ———————


				}




				17{

				##########################################
				# Exit  
				##########################################


				$Loop = $true
				Exit
				}

				}


				}
