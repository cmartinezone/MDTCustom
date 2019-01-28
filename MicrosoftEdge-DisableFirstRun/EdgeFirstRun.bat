:: Carlos Martinez Github @cmartinezone   Date:1/26/2018
:: Windows 10 v1809 customization (  Welcome to windows page, microsoft Edge Icon)

:: Disable Welcome to windows page in Microsoft Edge in the first login
REG LOAD HKLM\TempHive "%SYSTEMDRIVE%\Users\Default\NTUSER.DAT"
REG ADD "HKLM\TempHive\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d 00000000 /f
REG UNLOAD HKLM\TempHive

:: Remove Microsoft Edge icon from the desktop
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "DisableEdgeDesktopShortcutCreation" /t REG_DWORD /d "1" /f
