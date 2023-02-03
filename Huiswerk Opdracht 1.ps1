#HUISWERK AANPASSING SCRIPT
$Description = $null

'Geef een local user op '

$UserName = Read-Host

$UserObject = Get-LocalUser -Name $UserName


if($UserObject.Description -eq 'sales')
{
    'Weet je zeker dat je de beschrijving wilt aanpassen (j/n)'

    $Answer =Read-Host

    if($Answer -eq 'j')
    {

        Set-LocalUser -Name $UserObject.Name -Description 'support'

    }

    elseif($Answer -eq 'n')
    {
        
        'Ok dan niet!!!!'


    }
}

elseif($UserObject.Description -eq 'support')
{


    'Weet je zeker dat je de beschrijving wilt aanpassen (j/n)'

    $Answer =Read-Host

    if($Answer -eq 'j')
    {

        Set-LocalUser -Name $UserObject.Name -Description 'sales'

    }

    elseif($Answer -eq 'n')
    {
        
        'Ok dan niet!!!!'


    }

   
}
else
    {
        'Welke beschrijving zou je de gebruiker willen geven?'
        $Description = Read-Host
        Set-LocalUser -Name $UserObject.Name -Description $Description
        Get-LocalUser -Name $UserObject.Name
    }