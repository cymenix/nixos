Add-Type -AssemblyName System.Windows.Forms

function Is-PowerToysRunActive {
    $process = Get-Process -Name "PowerToys" -ErrorAction SilentlyContinue
    if ($process) {
        return $true
    }
    return $false
}

[System.Windows.Forms.SendKeys]::SendWait('% ')

while ($true) {
    if (-not (Is-PowerToysRunActive)) {
        break
    }
    Start-Sleep -Milliseconds 500
}

exit
