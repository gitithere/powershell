#  The Third section will query each computer in the ListOfComputers.txt to get the members of the local group Administrators
#  Found @ https://stackoverflow.com/questions/21288220/get-all-local-members-and-groups-displayed-together
#  Changed Path on Servers and Output
#  Added Progress Bar for Servers and Members

$Servers=Get-Content -Path "C:\Servers.txt" 
$output = 'C:\LocalAdmins.csv'
$results = @()

$objSID = New-Object System.Security.Principal.SecurityIdentifier("S-1-5-32-544")
$objgroup = $objSID.Translate( [System.Security.Principal.NTAccount])
$objgroupname = ($objgroup.Value).Split("\")[1]



foreach($server in $Servers)
{
    for ($I = 1; $I -le 100; $I++ )
#    {
#    Write-Host "Powershell Script In Progress $I% Complete"; << This is wrong but, great learning experience to write out $I as a percent to the console...
    {Write-Progress -Activity "Powershell Script In Progress-Servers...checking on Members... " -Status "$I% Complete:" -PercentComplete $I;} ###<<<This line works just needed to comment out the For $I For Loop

        $admins = @()
        $group =[ADSI]"WinNT://$server/$objgroupname" 
        $members = @($group.psbase.Invoke("Members"))
            $members | foreach {
                for($J = 1; $J -lt 100; $J++ )
                    {Write-Progress -Activity "Powershell Script In Progress-Members " -Status "$J% Complete:" -PercentComplete $J;}    

                    $obj = new-object psobject -Property @{
                    Server = $Server
                    Admin = $_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)
            }


        $admins += $obj
    } 
    $results += $admins


#    }
}
$results| Export-csv $Output -NoTypeInformation
