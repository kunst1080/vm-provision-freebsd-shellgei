@echo off
setlocal ENABLEDELAYEDEXPANSION

cd /d "%~dp0"


echo.
echo ----- load config
echo   loading config.bat
call config.bat
if exist config.user.bat echo   loading config.user.bat & call config.user.bat


echo.
echo ----- stop vm
%VMRUN_EXE% stop "%VM_VMX%"


echo.
echo ----- copy vm
if exist output rd /s /q output
xcopy /e %VM_TEMPLATE% output\


echo.
echo ----- run vmx
%VMRUN_EXE% start "%VM_VMX%"
%VMRUN_EXE% -gu root -gp vmpass listDirectoryInGuest "%VM_VMX%" > nul


echo.
echo ----- create provision directory
%VMRUN_EXE% -gu root -gp vmpass createDirectoryInGuest "%VM_VMX%" /provision
%VMRUN_EXE% -gu root -gp vmpass runProgramInGuest "%VM_VMX%" /bin/chmod +x /provision


echo.
echo ----- transfer provisioning scripts
set FILELIST=filelist.txt
if exist filelist.user.txt set FILELIST=%FILELIST%,filelist.user.txt
for /f "usebackq tokens=*" %%i in (%FILELIST%) do (
    if "%%~xi"==".txt"  set isAscii=true
    if "%%~xi"==".sh"   set isAscii=true
    if "%%~xi"==".list" set isAscii=true
    if "%%~xi"==".conf" set isAscii=true
    if "!isAscii!"=="true" (
        echo   transfer %%i ASCII mode
        %VMRUN_EXE% -gu root -gp vmpass CopyFileFromHostToGuest "%VM_VMX%" %%i /tmp/%%~nxi
        %VMRUN_EXE% -gu root -gp vmpass runProgramInGuest       "%VM_VMX%" /bin/sh -c "/usr/bin/tr -d '\015' < /tmp/%%~nxi > /provision/%%~nxi"
    ) ELSE (
        echo   transfer %%i BINARY mode
        %VMRUN_EXE% -gu root -gp vmpass CopyFileFromHostToGuest "%VM_VMX%" %%i /provision/%%~ni
    )
)


echo.
echo ----- adduser and transfer SSH key
%VMRUN_EXE% -gu root -gp vmpass CopyFileFromHostToGuest "%VM_VMX%" "%USER_SSHKEY%" /provision/authorized_keys
%VMRUN_EXE% -gu root -gp vmpass runProgramInGuest "%VM_VMX%" /bin/sh -c "/bin/sh /provision/provision-adduser.sh %USER_NAME% 1> /provision/provision-adduser.log 2>&1"
%VMRUN_EXE% -gu root -gp vmpass copyFileFromGuestToHost "%VM_VMX%" /provision/provision-adduser.log output\provision-adduser.log
type output\provision-adduser.log


echo.
echo ----- execute provisioning scripts (root)
%VMRUN_EXE% -gu root -gp vmpass runProgramInGuest "%VM_VMX%" /bin/sh -c "/bin/sh /provision/provision-root.sh 1> /provision/provision-root.log 2>&1"
%VMRUN_EXE% -gu root -gp vmpass copyFileFromGuestToHost "%VM_VMX%" /provision/provision-root.log output\provision-root.log
type output\provision-root.log


echo.
echo ----- execute provisioning scripts (user)
%VMRUN_EXE% -gu root -gp vmpass runProgramInGuest "%VM_VMX%" /bin/sh -c "/usr/local/bin/sudo -u %USER_NAME% /bin/sh /provision/provision-user.sh 1> /provision/provision-user.log 2>&1"
%VMRUN_EXE% -gu root -gp vmpass copyFileFromGuestToHost "%VM_VMX%" /provision/provision-user.log output\provision-user.log
type output\provision-user.log


echo.
echo ----- reboot
%VMRUN_EXE% reset "%VM_VMX%"

pause
