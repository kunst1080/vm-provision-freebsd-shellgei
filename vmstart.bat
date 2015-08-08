@echo off

cd /d "%~dp0"

call config.bat
if exist config.user.bat call config.user.bat

echo start VM:"%VM_VMX%"
%VMRUN_EXE% start "%VM_VMX%"

