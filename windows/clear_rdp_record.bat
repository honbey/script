@echo off
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Default" /va /f
del "%USERPROFILE%\My Documents\Default.rdp" /a
@exit
