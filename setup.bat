@echo off
echo ====================================
echo Flutter + Stitch AI Setup Script
echo ====================================
echo.

echo [1/4] Checking Flutter installation...
flutter --version
if %ERRORLEVEL% NEQ 0 (
    echo ✗ Flutter not found! Please install Flutter first.
    pause
    exit /b 1
)
echo ✓ Flutter found
echo.

echo [2/4] Installing dependencies...
flutter pub get
if %ERRORLEVEL% NEQ 0 (
    echo ✗ Failed to install dependencies!
    pause
    exit /b 1
)
echo ✓ Dependencies installed
echo.

echo [3/4] Generating JSON serialization code...
flutter pub run build_runner build --delete-conflicting-outputs
if %ERRORLEVEL% NEQ 0 (
    echo ✗ Failed to generate code!
    pause
    exit /b 1
)
echo ✓ Code generation completed
echo.

echo [4/4] Checking .env file...
if exist .env (
    echo ✓ .env file found
) else (
    echo ⚠ .env file not found!
    echo Creating .env from template...
    copy .env.example .env
    echo.
    echo ⚠ IMPORTANT: Please edit .env file and add your Stitch AI credentials!
    echo.
)

echo.
echo ====================================
echo ✓ Setup completed successfully!
echo ====================================
echo.
echo Next steps:
echo 1. Edit .env file with your Stitch AI credentials
echo 2. Run: flutter run
echo.
pause
