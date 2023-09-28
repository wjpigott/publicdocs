# Sample code and proofs of concept are provided for the purpose of illustration only and are not intended to be used in a production environment.  
# THE SAMPLE CODE AND PROOFS OF CONCEPT ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
# TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE. We grant you a nonexclusive, royalty-free right to use and 
# modify the sample code and to reproduce and distribute the object code form of the sample code, provided that you agree: (i) to not use 
# Microsoft’s name, logo, or trademarks to market your software product in which the sample code is embedded; (ii) to include a valid copyright 
# notice on your software product in which the sample code is embedded; (iii) to provide on behalf of and for the benefit of your subcontractors a 
# disclaimer of warranties, exclusion of liability for indirect and consequential damages and a reasonable limitation of liability;  and (iv) to 
# indemnify, hold harmless, and defend Microsoft, its affiliates  and suppliers from and against any third party claims or lawsuits, including 
# attorneys’ fees, that arise or result from the use or distribution of the sample code.
#
# Add tags to a list of Virtual Machines
#
# Ensure that you have Powershell AZ library installed
# https://learn.microsoft.com/en-us/powershell/azure/install-azps-windows?view=azps-10.4.1&tabs=powershell&pivots=windows-psgallery#installation
#
# Login to Azure 
function Login()  
{  
    $context = Get-AzContext  
  
    if (!$context)   
    {  
        Connect-AzAccount  
    }   
    else   
    {  
        Write-Host " Already connected to Azure"  
    }  
} 
Login
# Set-AzContext -Subscription <subscription name or id>
Set-AZContext -Subscription "Your subscrition name or ID"
# Set the recource group of the servers to be updated with tags
$ResourceGroup = "ArcDemo"
#
# Change the tags in line 20 to meet your needs, for example remove the "ARC Enabled" tag if not needed.
# In the servers.csv file open this in notepad and ensure that there is a blank line at the very end otherwise the last server will be skipped. 
# Ensure the servers.csv file in the same folder as the .ps1 folder
Function Update-Tags
{
param(
$VMName
)
$ComputerName = $_.VMName 
$tags = @{"ESU Usage"="WS2012 DEV TEST"; "ARC Enabled"="True"}
$resource = Get-AzResource -Name $ComputerName -ResourceGroup $ResourceGroup
Update-AzTag -ResourceId $resource.id -Tag $tags -Operation Merge
}
Import-CSV servers.csv | FOREACH { Try {Update-Tags –VMName $_.VMName}
catch{}
}


