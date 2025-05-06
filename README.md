My notes for configuring Windows 11 24H2 on the GPD Pocket 4.


## Installation From Scratch

The default Windows 11 24H2 image has all the necessary drivers to setup the Pocket 4, including Wi-Fi and storage drivers.

1. Prepare a Windows Install disk 
    
    <https://www.microsoft.com/en-us/software-download/windows11>

2. Install Windows
    - Screen will be rotated in portrait mode during installation and first boot, until you manually set it to landscape mode in Display Settings

3. Install missing drivers:
    - doubleclick `install.bat`, or `install.ps1` from the terminal.
    - this will prompt to install the rotation sensor, modem, and fingerprint sensor drivers.
    
    OR
    
    - Download the driver package from <https://gpd.hk/gpdpocket4firmware>, 
    - Currently it is v4.1.0 and 1.5 GB in size. 

4. Download the AMD driver updater. 

    <https://www.amd.com/en/support/download/drivers.html>

    - Install the latest AMD chipset and graphics drivers - if you have checked for Windows updates prior to running this the update may fail and require a restart as it will conflict with ongoing Windows updates.


5. (Optional) Install the DTS Audio Enhancement package provided by GPD.
This must be sourced directly from GPD as it includes activation keys. <https://gpd.hk/gpdpocket4firmware>


6. Install BIOS and EC update 
    - Find your BIOS and EC versions in `msinfo.exe`
    - Current BIOS and EC Versions:
        ```
        BIOS Version/Date	|   American Megatrends International, LLC. 2.07, 3/6/2025
        Embedded Controller |   Version	1.11
        ```
    - The latest BIOS and EC updaters can be sourced from GPD.

7. Install keyboard firmware update

    - The latest keyboard updater can be sourced from GPD.

8. (Optional) Update Intel AX210 Wi-Fi driver

    - Occasionally the AX210 does not resume from suspend on the version of the driver shipped through Windows update.

    <https://www.intel.com/content/www/us/en/download/19351/intel-wireless-wi-fi-drivers-for-windows-10-and-windows-11.html>


## Touchpad

The Hailuck touchpad reports itself as a traditional mouse pointer and keyboard device in Windows (and Linux).

Flipping the two-finger scroll direction can be accomplished via registry edits, followed by restarting the device.

This does not change the two finger zoom gesture direction.

```Powershell
Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Enum\HID\VID_258A&PID_000C&MI_01&Col01\8&146c7df7&0&0000\Device Parameters" -Name "FlipFlopWheel" -Type DWord -Value 1

Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Enum\HID\VID_258A&PID_000C&MI_01&Col01\8&146c7df7&0&0000\Device Parameters" -Name "FlipFlopHScroll" -Type DWord -Value 1
```

# Touchscreen HID Device

Occasionaly the i2c HID device that is the touchscreen layer does not resume form suspend - and reports its status in Device Manager as malfunctioning.

Disabling/Enabling the device restores the touch function - this can be done in Device Manager or Powershell (as Admin).

```Powershell
    Disable-PnpDevice -InstanceId "ACPI\NVTK0603\4" -Confirm:$false
    Enable-PnpDevice -InstanceId "ACPI\NVTK0603\4" -Confirm:$false
```

I've put this a script `ResetTouchScreen.ps1`, this can be setup as a scheduled task in Task Scheduler. 

## Drivers to find manufacturer sources of

Ideally manufacturers or Windows update would provide all of these drivers, that are currently only avaialble on the GPD Pocket 4 page.

<https://gpd.hk/gpdpocket4firmware>

### MEMSIC mxc6655 rotation sensor driver
```
Device IDs: ACPI\MXC6655
DriverVer: 07/31/2019, 11.5.11.123
```
Possibly newer versions of this driver can be found in the windows update catalog, with the same ACPI ID.

### FocalTech fingerprint sensor driver and biometric service
```
Device IDs: USB\VID_2808&PID_0752, USB\VID_2808&PID_C652
DriverVer: 10/28/2024, 5.2.69.24
```
I've not found a manufacturer hosted version of this driver, nor is it in the windows update catalog (other versions of the FocalTech driver are, but for different device IDs)

### Quectel EG25-GL Modem
```
Device IDs: USB\VID_2C7C&PID_0125
DriverVer: 9/3/2019, 15.12.14.854
```

Quectel presumably provides this and newer versions of the driver on their website - but its not available for public download and requires an approved account.