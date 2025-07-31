@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo =======================================
echo MP4 파일 전송 및 앱 설치 스크립트
echo =======================================

:: STEP 1 - 장비 접속 비밀번호 입력
set /p PASSWORD=장비 접속 비밀번호 입력 (예: admin123): 

echo.
echo [1] 장비 연결 확인 중...
adb devices

echo.
echo [2] 장비 로그인 시도 중...
adb shell password %PASSWORD%
IF %ERRORLEVEL% NEQ 0 (
    echo 로그인 실패. 비밀번호를 다시 확인하세요.
    pause
    exit /b
)
echo 로그인 성공

:: STEP 3 - /sdcard/Movies/test 폴더 생성
echo.
echo [3] 'Movies/test' 폴더 생성 중...
adb shell "mkdir -p /sdcard/Movies/test"

:: STEP 4 - 현재 폴더의 모든 MP4 파일 복사
echo.
echo [4] 현재 폴더에서 모든 MP4 파일을 전송합니다...
for %%f in (*.mp4) do (
    echo 파일 전송 중: %%f
    adb push "%%f" /sdcard/Movies/test/
)
echo MP4 파일 전송 완료

:: STEP 5 - 현재 폴더의 APK 자동 설치
echo.
echo [5] 현재 폴더에서 APK 파일을 찾고 설치합니다...
set APKFOUND=
for %%f in (*.apk) do (
    set APKFOUND=%%f
    goto :INSTALLAPK
)

echo APK 파일이 현재 폴더에 없습니다. APK 파일을 같은 폴더에 넣어주세요.
pause
exit /b

:INSTALLAPK
echo 설치할 APK: %APKFOUND%
adb install -r "%APKFOUND%"
IF %ERRORLEVEL% NEQ 0 (
    echo APK 설치 실패. APK 파일을 다시 확인해주세요.
    pause
    exit /b
)
echo APK 설치 완료

:: STEP 6 - Android 설정 앱 실행 (권한 설정)
echo.
echo [6] 설정 앱을 실행합니다. ES 앱의 권한을 모두 허용해주세요.
adb shell am start -a android.settings.SETTINGS

pause

:: STEP 7 - ES 앱 실행
echo.
echo [7] ES 앱을 실행합니다. Movies/test 에서 MP4 파일을 찾아 재생해주세요.
adb shell monkey -p com.estrongs.android.pop -c android.intent.category.LAUNCHER 1

echo.
echo 모든 작업이 완료되었습니다
pause
