$Username = $null
$FirstName = $null
$LastName = $null
$OU = $null
$TestOU = $null
$Password = $null
$Confirmation = $null

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

if ($null-eq $TestOU) # Ik had het eerst omgedraaid. Maar visual studio code adviseerde my by gebruik van $null dit om te draaien dus van daar dat het nu ook weer anders om staat :)
{

    $Confirmation = Read-Host "Moet de gebruiker $Firstname $Lastname echt aangemaakt worden (j/n)"

    if ($Confirmation -eq "j") 
    {    
        New-ADOrganizationalUnit -Name $OU # De reden dat ik nu pas de OU aanmaak is om vervuiling in het AD te voorkomen als er gekozen word om geen gebruiker aan te maken.
        'Nieuwe OU '+$OU +' is aangemaakt'
        New-ADUser -Name $Username -GivenName $FirstName -Surname $LastName -AccountPassword $Password -Path "OU=$OU,DC=ADATUM,DC=COM" -Enabled $true
        Get-ADUser -Identity $Username # Wil alleen de output wergeven als er daadwerkelijk een gebruiker is aangemaakt.

    }
    elseif ($Confirmation -eq "n") 
    {
        "Je hebt er voor gekozen om de gebruiker $Firstname $Lastname niet aan te maken"
    } 
    else
    {
        Write-Error -Message "Error je heb een verkeerde waarde ingevoerd bij de keuze voor het aanmaken van een gebruiker !!! Er is daarom niets uitgevoerd."
    }
    
}
elseif ($null -ne $TestOU)
{
    'OU bestaat Al.'
    'We maken geen nieuwe OU '+$OU +' aan'
    $Confirmation = Read-Host "Moet de gebruiker $Firstname $Lastname echt aangemaakt worden (j/n)"

    if ($Confirmation -eq "j") 
    {    
        New-ADUser -Name $Username -GivenName $FirstName -Surname $LastName -AccountPassword $Password -Path "OU=$OU,DC=ADATUM,DC=COM" -Enabled $true
        Get-ADUser -Identity $Username
    }
    elseif ($Confirmation -eq "n") 
    {
        "Je hebt er voor gekozen om de gebruiker $Firstname $Lastname niet aan te maken"
    } 
    else
    {
        Write-Error -Message "Error je heb een verkeerde waarde ingevoerd bij de keuze voor het aanmaken van een gebruiker !!! Er is daarom niets uitgevoerd."
    }
}