#Voorbeeld 1
Write-Output 'Powershell Rocks' 

#Voorbeeld 2
Write-Output 'Wat wil je zeggen'
$waarde = Read-Host
Write-Output $waarde

#Voorbeeld 3
Write-Output 'Welke Gebruiker ?'
$waarde = Read-Host
Get-LocalUser | Where-Object {$_.name -eq $waarde} | Disable-LocalUser

#Voorbeeld 4
Write-Output 'Welke service- moet gestopt worden?'
$stopservice = Read-Host
Get-Service $stopservice | Where-Object {$_.Status -eq 'Running'} | Stop-Service