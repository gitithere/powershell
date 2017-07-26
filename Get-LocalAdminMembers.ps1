#  The Third section will query each computer in the ListOfComputers.txt to get the members of the local group Administrators
#  Found @ https://stackoverflow.com/questions/21288220/get-all-local-members-and-groups-displayed-together
#  Changed Path on Servers and Output
$Servers=Get-Content -Path "Servers.txt" 
$output = 'LocalAdmins.csv'
$results = @()

$objSID = New-Object System.Security.Principal.SecurityIdentifier("S-1-5-32-544")
$objgroup = $objSID.Translate( [System.Security.Principal.NTAccount])
$objgroupname = ($objgroup.Value).Split("\")[1]

foreach($server in $Servers)
{
$admins = @()
$group =[ADSI]"WinNT://$server/$objgroupname" 
$members = @($group.psbase.Invoke("Members"))
    $members | foreach {
        $obj = new-object psobject -Property @{
        Server = $Server
        Admin = $_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)
        }
    $admins += $obj
    } 
$results += $admins
}
$results| Export-csv $Output -NoTypeInformation
