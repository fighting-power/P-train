$OU = $null
$TestOU = $null

"Geef de naam van de OU op waarnaar de gebruikers verplaatst moeten worden"
$OU = Read-Host

$TestOU = Get-ADOrganizationalUnit -Identity "OU=$OU,DC=ADATUM,DC=COM" -ErrorAction SilentlyContinue

if ($null -eq $TestOU)
{
    New-ADOrganizationalUnit -Name $OU -ErrorAction Stop
    'Nieuwe OU '+$OU +' is aangemaakt'
    Get-ADUser -Filter 'Description -eq "lotr"' | Move-AdObject -TargetPath "OU=$OU,DC=ADATUM,DC=COM"
}
elseif ($null -ne $TestOU)
{
    'OU bestaat al.'
    'We maken geen nieuwe OU '+$OU +' aan'
    Get-ADUser -Filter 'Description -eq "lotr"' | Move-AdObject -TargetPath "OU=$OU,DC=ADATUM,DC=COM"
}
Get-ADUser -Filter 'Description -eq "lotr"'