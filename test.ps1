#Variablen
$log = "E:\Reboot-RDS\LOG\$(get-date -f yyyy-MM-dd)_RebootRDServers_Week1.log.txt"
$rdServers = "NLDSLRDPRD001.care4go.nl", "NLDSLRDPRD002.care4go.nl"
$broker = "NLDSLRDBRO03.CARE4GO.NL"
$allserversindrain = $null
$activesessions = Get-RDUserSession -ConnectionBroker nldslrdbro03.care4go.nl | select CollectionName,HostServer,Username,CreateTime,DisconnectTime,UnifiedSessionID | where {$rdServers -like $_.HostServer}

#Functies
Function Send-Telegram {
Param([Parameter(Mandatory=$true)][String]$Message)
$Telegramtoken = "6042896264:AAFuHZaRUoxA59E3CbOWNQE4hkzH-krAhvc"
$Telegramchatid = "-1001369819626"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$Response = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($Telegramtoken)/sendMessage?chat_id=$($Telegramchatid)&text=$($Message)&parse_mode=markdown"}

Function Send-Telegram-Arnoud {
Param([Parameter(Mandatory=$true)][String]$Message_A)
$Telegramtoken_A = "6042896264:AAFuHZaRUoxA59E3CbOWNQE4hkzH-krAhvc"
$Telegramchatid_A = "-1001932102000"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$Response = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($Telegramtoken_A)/sendMessage?chat_id=$($Telegramchatid_A)&text=$($Message_A)&parse_mode=markdown"}

#Controle of servers in drain staan op de broker
foreach($server in $rdServers){
    $session = Get-RDSessionHost -ConnectionBroker $broker -CollectionName 'PRD-RDS2012' | Where-Object {$_.sessionhost -eq $server}
    if($session.NewConnectionAllowed -eq 'No'){
        Write-Output "$(get-date -f "dd-MM-yyyy HH:mm") - De server $server staat in drain" | Out-File -FilePath $log -append
    }
    else{
        Write-Output "$(get-date -f "dd-MM-yyyy HH:mm") - De server $server staat niet in drain" | Out-File -FilePath $log -append
        $allserversindrain = $false
    }
}
if ($allserversindrain -eq $false){
    Write-Output "$(get-date -f "dd-MM-yyyy HH:mm") - Een van de servers staat niet meer in drain. Controleer log welke server" | Out-File -FilePath $log -append
    Send-Telegram-Arnoud -Message "*Geplande herstart $($rdServers)*

    Gepland onderhoud $($rdServers) is mislukt! Een van de servers staat niet meer in drain!
    Controleer logs om te zien waar het fout is gegaan"
    Write-Error "Een van de servers staat niet meer in drain." -ErrorAction Stop
}

$activesessions = Get-RDUserSession -ConnectionBroker $broker | select CollectionName,HostServer,Username,CreateTime,DisconnectTime,UnifiedSessionID | where {$rdServers -like $_.HostServer}
foreach($user in $activesessions){
Send-RDUserMessage -HostServer $user.Hostserver -UnifiedSessionID $user.UnifiedSessionId -MessageTitle "Bericht van ICT CuraMare" -MessageBody "Deze server gaat over 5 minuten herstarten. `nGraag uw werk opslaan en afmelden om data verlies te voorkomen."
} 

Start-Sleep -Seconds 300
Restart-Computer -ComputerName $rdServers -Wait -For PowerShell -Timeout 300 -Delay 2 -Force
Write-Output "Script heeft gelopen en en servers zijn herstart"
Set-RDSessionHost -SessionHost $rdServers -NewConnectionAllowed yes -ConnectionBroker $broker
Send-Telegram -Message "*Herstart $($rdServers)*

De servers $($rdServers) zijn uit drain en weer beschikbaar voor aanmelden."