@echo off
REM Master Startup Script
REM %~dp0 refers to the folder where this script is located (C:\Users\liker\scripts\)

call "%~dp0startup_modules\00_cleanup.bat"

call "%~dp0startup_modules\10_core.bat"

timeout /t 1 /nobreak >nul
call "%~dp0startup_modules\20_utils.bat"

timeout /t 2 /nobreak >nul
call "%~dp0startup_modules\30_interface.bat"

timeout /t 2 /nobreak >nul
call "%~dp0startup_modules\40_heavy.bat"

exit
