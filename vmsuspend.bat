@echo off

cd /d "%~dp0"

call config.bat
if exist config.user.bat call config.user.bat

echo suspend VM:"%VM_VMX%"
%VMRUN_EXE% suspend "%VM_VMX%"

