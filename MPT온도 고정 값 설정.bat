@echo off
chcp 65001 >nul
title 온도 고정값 자동 설정 스크립트
echo ===============================
echo  장비 ADB 접속 및 온도 설정
echo ===============================

set /p pw=장비 접속 비밀번호 입력 (예: admin123): 

echo.
echo [1] 장비 연결 확인 중...
adb devices
if errorlevel 1 (
    echo ADB 장비 연결에 실패했습니다. 장비가 연결되었는지 확인하세요.
    pause
    exit /b
)


echo.
echo [2] 장비 로그인 시도 중...
adb shell password %pw%


echo.
echo [3] 온도 25도 고정값 설정 중...
adb shell "lamybase_tool misc runShell 'echo 25 > /sys/devices/platform/battery/Battery_Temperature'"


echo.
echo [4] 설정된 온도 확인 중...
adb shell "lamybase_tool misc runShell \"cat sys/class/power_supply/battery/temp\""

echo.
echo 완료되었습니다.
pause
