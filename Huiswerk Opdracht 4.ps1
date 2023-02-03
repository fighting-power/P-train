$Username = $null
$FirstName = $null
$LastName = $null
$OU = $null
$TestOU = $null
$Password = $null

"Geef de Gebruikersnaam van de aan te maken gebruiker op alsjeblieft?"
$Username = Read-Host

"Geef de Voornaam van de aan te maken gebruiker op alsjeblieft?"
$FirstName = Read-Host

"Geef de Achternaam van de aan te maken gebruiker op alsjeblieft?"
$LastName = Read-Host

"Geef het aan te maken wachtwoord voor de gebruiker op alsjeblieft"
$Password = Read-Host -AsSecureString

"Geef de naam van de OU op waarin de gebruiker aangemaakt moet worden?"
$OU = Read-Host

$TestOU = Get-ADOrganizationalUnit -Identity "OU=$OU,DC=ADATUM,DC=COM" -ErrorAction SilentlyContinue

if ($null-eq $TestOU)
{
New-ADOrganizationalUnit -Name $OU
'Nieuwe OU '+$OU +' is aangemaakt'
New-ADUser -Name $Username -GivenName $FirstName -Surname $LastName -AccountPassword $Password -Path "OU=$OU,DC=ADATUM,DC=COM" -Enabled $true
Get-ADUser -Identity $Username
}
else
{
'OU bestaat Al.'
'We maken geen nieuwe '+$OU +' aan'
New-ADUser -Name $Username -GivenName $FirstName -Surname $LastName -AccountPassword $Password -Path "OU=$OU,DC=ADATUM,DC=COM" -Enabled $true
Get-ADUser -Identity $Username
}