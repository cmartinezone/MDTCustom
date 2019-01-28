:: Carlos Martinez Github @cmartinezone   Date:1/27/2018
:: Windows 10 customization (  Disable Windows Login Animation)


:: Disable Windows Login Animation
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableFirstLogonAnimation" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "EnableFirstLogonAnimation" /t REG_DWORD /d "0" /f