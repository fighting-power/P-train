function Test-ADOU
{
Param([Parameter (Mandatory,ValueFromPipeline)] [String[]]$Name)
PROCESS{

foreach ($item in $Name)
{
$TestOU = Get-ADOrganizationalUnit -Filter 'Name -like "*"' | Where-Object { $_.name -eq $Name}


if ($TestOU -eq $null)
{
    $Exsist = $false
}

elseif ($TestOU -ne $null)
{
    $Exsist = $true
}
else
{
Write-Output 'Error Occoured'
}
$i++
Write-Output $TestOU
Write-Output $Exsist
}
}
}
