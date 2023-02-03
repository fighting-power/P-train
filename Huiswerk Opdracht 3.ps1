$Username = $null
$Password = $null

"Geef de naam van de aan te maken gebruiker op alsjeblieft?"
$Username = Read-Host

"Geef het aan te maken wachtwoord voor de gebruiker op alsjeblieft"
$Password = Read-Host -AsSecureString

New-ADUser -Name $username -AccountPassword $Password -Enabled $true