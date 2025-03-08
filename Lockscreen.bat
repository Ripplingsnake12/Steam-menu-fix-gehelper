@echo off
:: Ensure the script is run as administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ====================================================
    echo This script must be run with administrative privileges.
    echo Please right-click on the script and select "Run as administrator."
    echo ====================================================
    pause
    exit /b
)

echo Disabling Windows 11 Lock Screen...
:: Add registry key to disable the lock screen
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v NoLockScreen /t REG_DWORD /d 1 /f

echo Disabling Login Password Requirement...
:: Disable PasswordLess sign-in to enable automatic login
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\PasswordLess\Device" /v DevicePasswordLessBuildVersion /t REG_DWORD /d 0 /f

:: Automatically log in the current user
echo Configuring automatic login for current user...
for /f "tokens=2*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName') do set DefaultUserName=%%B
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /t REG_SZ /d "%DefaultUserName%" /f

:: Prompt user for password (if necessary)
set /p DefaultPassword="Enter your account password (leave blank if none): "
if not "%DefaultPassword%"=="" (
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /t REG_SZ /d "%DefaultPassword%" /f
)

echo Disabling Welcome Experience and Tips...
:: Use PowerShell to disable welcome experience and tips
powershell -Command "
New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement -Force | Out-Null;
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement -Name ScoobeSystemSettingEnabled -Value 0;
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement -Name SettingsNotificationEnabled -Value 0;
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\AppHost' -Name EnableWebContentEvaluation -Value 0;
"

:: Disable tips and suggestions in notifications
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v ScoobeSystemSettingEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\InputPersonalization" /v RestrictImplicitTextCollection /t REG_DWORD /d 1 /f

echo All tasks completed. Please restart your computer for changes to take effect.
pause
