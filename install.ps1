if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {  
    $arguments = "-ExecutionPolicy ByPass -NoExit & '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
}

Split-Path $myinvocation.mycommand.definition -Parent | Set-Location 
Get-Location

if (Test-Path -Path "pocketdrivers") {
    $c = Read-Host "Previous 'pocketdrivers' folder found - delete? [y/N]"
    if ($c -eq "y") {
        Remove-Item "drivers" -Recurse
        Expand-Archive "pocketdrivers.zip"
    }
}
else {
    Expand-Archive "pocketdrivers.zip"
}

Write-Host "Installing drivers..."

$c = Read-Host "Install fingerprint sensor driver? [y/N]"
if ($c -eq "y") {
    & pnputil.exe /add-driver  drivers/fingerprint_driver/*.inf /subdirs /install
}

Write-Host ""
Write-Host ""
$c = Read-Host "Install rotation sensor driver? [y/N]"
if ($c -eq "y") {
    & pnputil.exe /add-driver  drivers/rotation/*.inf /subdirs /install
}

Write-Host ""
Write-Host ""
$c = Read-Host "Install EG25-GL modem drivers? [y/N]"
if ($c -eq "y") {
    & pnputil.exe /add-driver  drivers/modem/*.inf /subdirs /install
}

Write-Host ""
Write-Host ""
$c = Read-Host "Press enter to exit"