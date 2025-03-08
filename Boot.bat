@echo off
title Safe Mode Boot Manager

echo Choose an option:

echo 1. Boot into Safe Mode
echo 2. Boot into Normal Mode

choice /c 12 /n /m "Enter your choice: "

if errorlevel 2 goto :normal_boot
if errorlevel 1 goto :safe_boot

:safe_boot
echo Setting boot configuration for Safe Mode...
bcdedit /set {current} safeboot minimal
shutdown /r /t 0
exit

:normal_boot
echo Setting boot configuration for Normal Mode...
bcdedit /deletevalue {current} safeboot
shutdown /r /t 0
exit