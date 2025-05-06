$dev = Get-PnpDevice -InstanceId "ACPI\NVTK0603\4"

if ($dev.Status -ne "OK") {
    Write-Host "Touchscreen reported `"" -NoNewLine
    Write-Host $dev.Status -ForegroundColor Red -NoNewline
    Write-Host "`" - reseting..." -NoNewline

    Disable-PnpDevice -InstanceId "ACPI\NVTK0603\4" -Confirm:$false
    Start-Sleep -Seconds 2
    Enable-PnpDevice -InstanceId "ACPI\NVTK0603\4" -Confirm:$false
    
    $dev = Get-PnpDevice -InstanceId "ACPI\NVTK0603\4"
    if ($dev.Status -eq "OK") {
        Write-Host "[OK]" -ForegroundColor Green
    }
    else {
        Write-Host "[FAIL]" -ForegroundColor Red
    }
}
else {
    Write-Host "Touchscreen reported `"" -NoNewLine
    Write-Host $dev.Status -ForegroundColor Green -NoNewline
    Write-Host "`" - no action required" 
}