# ⚡ Quick Commands Reference

Daftar command yang sering digunakan untuk development Flutter + Stitch AI.

## 🚀 Setup Commands

### Initial Setup
```bash
# Install dependencies
flutter pub get

# Generate JSON serialization code
flutter pub run build_runner build --delete-conflicting-outputs

# Setup environment file (manual edit required)
cp .env.example .env
```

### Windows One-Click Setup
```bash
# Run automated setup
setup.bat
```

---

## 🔨 Development Commands

### Run Application
```bash
# Run on connected device/emulator
flutter run

# Run on specific device
flutter devices
flutter run -d <device-id>

# Run with hot reload (default)
flutter run

# Run in release mode
flutter run --release
```

### Code Generation
```bash
# Generate code untuk JSON serialization
flutter pub run build_runner build

# Generate dengan delete conflicting outputs
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate on file changes)
flutter pub run build_runner watch

# Quick generate (Windows)
generate.bat
```

### Clean & Rebuild
```bash
# Clean build artifacts
flutter clean

# Get dependencies
flutter pub get

# Full clean & rebuild
flutter clean && flutter pub get && flutter run
```

---

## 🧪 Testing Commands

### Run Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage
```

### Check Code
```bash
# Analyze code
flutter analyze

# Format code
flutter format lib/

# Check format (without changing)
flutter format --set-exit-if-changed lib/
```

---

## 📦 Build Commands

### Android
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# Split APKs per ABI
flutter build apk --split-per-abi

# App Bundle (for Play Store)
flutter build appbundle --release
```

### iOS
```bash
# Build iOS
flutter build ios --release

# Build with specific configuration
flutter build ios --release --no-codesign
```

### Web
```bash
# Build web
flutter build web

# Build with specific renderer
flutter build web --web-renderer html
flutter build web --web-renderer canvaskit
```

### Desktop
```bash
# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

---

## 🔍 Debugging Commands

### Flutter Doctor
```bash
# Check Flutter installation
flutter doctor

# Verbose output
flutter doctor -v

# Accept Android licenses
flutter doctor --android-licenses
```

### Logs & Debug
```bash
# View logs
flutter logs

# Clear logs
flutter logs --clear

# Attach to running app
flutter attach
```

### Device Management
```bash
# List devices
flutter devices

# List emulators
flutter emulators

# Launch emulator
flutter emulators --launch <emulator-id>
```

---

## 📊 Performance Commands

### Performance Profiling
```bash
# Profile mode
flutter run --profile

# Release mode with debugging
flutter run --release --enable-dart-profiling
```

### Size Analysis
```bash
# Analyze app size
flutter build apk --analyze-size
flutter build appbundle --analyze-size
flutter build ios --analyze-size
```

---

## 🔄 Update Commands

### Update Flutter
```bash
# Update Flutter SDK
flutter upgrade

# Update packages
flutter pub upgrade

# Get latest packages
flutter pub outdated
```

### Downgrade
```bash
# Downgrade Flutter
flutter downgrade

# Use specific Flutter version
flutter version <version>
```

---

## 🛠️ Maintenance Commands

### Cache Management
```bash
# Clear Flutter cache
flutter pub cache clean
flutter pub cache repair

# Clean downloads
flutter clean
```

### Dependencies
```bash
# Add package
flutter pub add <package_name>

# Remove package
flutter pub remove <package_name>

# Show dependency tree
flutter pub deps

# Show outdated packages
flutter pub outdated
```

---

## 🎯 Project-Specific Commands

### Stitch AI Integration

#### Check Configuration
```bash
# Run app and check console for:
# ✓ Environment variables loaded
# Configured: ✓ Yes
flutter run
```

#### Regenerate Models
```bash
# If you modify model files
flutter pub run build_runner build --delete-conflicting-outputs
```

#### Reset Configuration
```bash
# Reset .env file
cp .env.example .env
# Then edit .env with your credentials
```

---

## 🐛 Troubleshooting Commands

### Fix Common Issues

#### Gradle Issues (Android)
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

#### Pods Issues (iOS)
```bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter clean
flutter pub get
```

#### Build Issues
```bash
# Full reset
flutter clean
rm -rf build/
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

#### Dependencies Issues
```bash
# Reset pub cache
flutter pub cache repair

# Force get dependencies
flutter pub get --no-precompile
```

---

## 📱 Emulator Commands

### Android Emulator
```bash
# List emulators
flutter emulators

# Launch specific emulator
flutter emulators --launch <emulator-id>

# Create new emulator (via Android Studio)
# Tools → AVD Manager → Create Virtual Device
```

### iOS Simulator
```bash
# List simulators
xcrun simctl list devices

# Boot simulator
open -a Simulator

# Or use Flutter
flutter run
```

---

## 🚦 Git Commands (Optional)

### Initial Commit
```bash
git init
git add .
git commit -m "Initial commit: Flutter + Stitch AI integration"
```

### Ignore .env File
```bash
# .env should already be in .gitignore
# Verify:
cat .gitignore | grep .env

# If accidentally committed:
git rm --cached .env
git commit -m "Remove .env from tracking"
```

---

## 💡 Pro Tips

### Alias Setup (Optional)

Add to your shell profile (`.bashrc`, `.zshrc`, etc.):

```bash
# Flutter aliases
alias frun="flutter run"
alias fbuild="flutter build"
alias fclean="flutter clean && flutter pub get"
alias fgen="flutter pub run build_runner build --delete-conflicting-outputs"
alias fdoc="flutter doctor"
alias ftest="flutter test"
```

### Useful Combinations

```bash
# Full reset and run
flutter clean && flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs && flutter run

# Quick format and analyze
flutter format lib/ && flutter analyze

# Build all platforms (if configured)
flutter build apk --release && flutter build appbundle --release && flutter build web
```

---

## 📋 Checklist Commands

### Before Commit
```bash
flutter format lib/
flutter analyze
flutter test
```

### Before Release
```bash
flutter doctor
flutter analyze
flutter test
flutter build apk --release
flutter build appbundle --release
```

### After Pull/Clone
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
cp .env.example .env
# Edit .env with your credentials
flutter run
```

---

## 🔗 Quick Links

- Flutter Commands: https://docs.flutter.dev/reference/flutter-cli
- Pub Commands: https://dart.dev/tools/pub/cmd
- Build Runner: https://pub.dev/packages/build_runner

---

**Bookmark this file untuk referensi cepat! 📌**
