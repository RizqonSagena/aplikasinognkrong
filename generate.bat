@echo off
echo ====================================
echo Generating JSON Serialization Code
echo ====================================
echo.

echo Running build_runner...
flutter pub run build_runner build --delete-conflicting-outputs

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ====================================
    echo ✓ Generation completed successfully!
    echo ====================================
) else (
    echo.
    echo ====================================
    echo ✗ Generation failed!
    echo ====================================
    exit /b 1
)

echo.
pause
