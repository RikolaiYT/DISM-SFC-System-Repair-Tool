@echo off
title System Repair Tool

chcp 866 >nul
color 0B

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Запрос прав администратора...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo.
echo =====================================
echo      ВОССТАНОВЛЕНИЕ СИСТЕМЫ
echo =====================================
echo.

echo [1/4] Проверка образа (CheckHealth)...
dism /online /cleanup-image /checkhealth
echo.

echo [2/4] Глубокая проверка (ScanHealth)...
dism /online /cleanup-image /scanhealth
echo.

echo [3/4] Восстановление (RestoreHealth)...
dism /online /cleanup-image /restorehealth
echo.

echo [4/4] Проверка системных файлов (SFC)...
sfc /scannow
echo.

echo =====================================
echo            ГОТОВО
echo =====================================
echo.


:: Подтверждение выхода
choice /c YN /m "Вы уверены, что хотите закрыть?"
if errorlevel 2 goto stay
if errorlevel 1 exit

:stay
echo.
echo Закрытие отменено.
pause
exit