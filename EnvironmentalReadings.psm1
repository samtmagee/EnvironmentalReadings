Set-StrictMode -Version Latest

function Get-EnvironmentalReadings {
    param (
        [Parameter(Mandatory)]
        [ValidateScript( { ($_ -match [IpAddress]$_) } ) ]
        $ip ,

        $path = "$env:USERPROFILE\EnvironmentalReadings.csv"
    )

    $date = Get-Date
    $temperature = Invoke-RestMethod -Uri "http://$($ip)/temperature" -ErrorAction Stop
    $humidity = Invoke-RestMethod -Uri "http://$($ip)/humidity" -ErrorAction Stop

    $climate = [PSCustomObject]@{
        'datetime'       = $date
        'temperature(C)' = $temperature
        'humidity(%)'    = $humidity
    }

    $climate | Export-Csv -Path $path -Append -NoTypeInformation -ErrorAction Stop
}
