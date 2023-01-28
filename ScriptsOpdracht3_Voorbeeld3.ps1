$input = $null
$user = $null


'Vul de naam van de gebruiker in.'
$input = Read-Host
$user = Get-LocalUser -Name $input
'\'
if($user.Description -eq 'Support')
{
    'De Gebruiker ' +$user.name  +'heeft als description ' +$user.Description +'dit word aangepast naar Sales.'
    Set-LocalUser -Name $user.name -Description 'Sales'
}
elseif ($user.Description -eq 'Sales')
{
    'De Gebruiker ' +$user.name  +'heeft als description ' +$user.Description +'dit word aangepast naar Support. `n'
    Set-LocalUser -Name $user.name -Description 'Support'
}
else
{
'Error'
}
Get-LocalUser $user.Name