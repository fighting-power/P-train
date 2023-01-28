$naam = ''

Write-Output = 'Hoe heet jij?'
$naam = Read-Host

if($naam -eq "Jan")
{
Write-Output "Je naam is $naam"
}
elseif ($naam -eq 'Piet')
{
Write-Output "Ga je melden bij de directie $naam"
}
else
{
Write-Output "Ik ken jou niet $naam"
}