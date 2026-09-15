# 📖 Setup Guide - Step by Step

Panduan lengkap untuk setup project Flutter dengan integrasi Stitch AI dari awal.

## 🎯 Prerequisites

Sebelum memulai, pastikan Anda sudah install:

- ✅ Flutter SDK (v3.0.0 atau lebih baru)
- ✅ Dart SDK (v3.0.0 atau lebih baru)
- ✅ Android Studio / VS Code dengan Flutter extension
- ✅ Git (optional)
- ✅ Stitch AI Account

## 📋 Step-by-Step Installation

### Step 1: Verify Flutter Installation

```bash
flutter doctor
```

Pastikan semua check marks hijau atau setidaknya Flutter dan Dart terinstall dengan baik.

### Step 2: Get Project Files

Jika project sudah ada:
```bash
cd aplikasinognkrong
```

Jika membuat baru, file-file sudah tersedia di folder ini.

### Step 3: Install Dependencies

```bash
flutter pub get
```

**Output yang diharapkan:**
```
Running "flutter pub get" in aplikasinognkrong...
Resolving dependencies...
+ http 1.1.0
+ provider 6.1.1
+ flutter_dotenv 5.1.0
+ json_annotation 4.8.1
...
Changed X dependencies!
```

### Step 4: Generate JSON Serialization Code

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**Output yang diharapkan:**
```
[INFO] Generating build script...
[INFO] Generating build script completed, took 2.1s
[INFO] Creating build script snapshot...
[INFO] Creating build script snapshot completed, took 3.2s
[INFO] Building new asset graph...
[INFO] Building new asset graph completed, took 1.5s
[INFO] Checking for unexpected pre-existing outputs...
[INFO] Deleting X declared outputs which already existed on disk.
[INFO] Running build...
[INFO] Running build completed, took 4.2s
[INFO] Caching finalized dependency graph...
[INFO] Caching finalized dependency graph completed, took 0.2s
[SUCCESS] Build completed successfully!
```

**File yang akan digenerate:**
- `lib/models/stitch_message.g.dart`
- `lib/models/stitch_request.g.dart`
- `lib/models/stitch_response.g.dart`
- `lib/models/stitch_error.g.dart`

### Step 5: Setup Stitch AI Credentials

#### 5.1 Login ke Stitch AI Dashboard

1. Buka browser dan kunjungi: https://stitch.tech/
2. Login dengan akun Anda
3. Jika belum punya akun, daftar terlebih dahulu

#### 5.2 Dapatkan API Key

1. Di dashboard, pergi ke **Settings** atau **API Keys**
2. Click **Create New API Key** atau **Generate API Key**
3. Copy API key yang digenerate (simpan di tempat aman!)
4. **PENTING**: API key ini hanya ditampilkan sekali!

#### 5.3 Dapatkan Agent ID

1. Di dashboard, pergi ke **Agents** atau **My Agents**
2. Pilih agent yang ingin Anda gunakan (atau buat baru)
3. Copy **Agent ID** (biasanya format: `agent_xxxxxxxxxxxxx`)

#### 5.4 Configure Environment Variables

1. **Copy template file:**
   ```bash
   cp .env.example .env
   ```

2. **Edit file `.env`:**
   
   Buka file `.env` dengan text editor dan isi dengan credentials Anda:
   
   ```env
   STITCH_API_KEY=sk_xxxxxxxxxxxxxxxxxxxxx
   STITCH_API_URL=https://api.stitch.tech/v1
   STITCH_AGENT_ID=agent_xxxxxxxxxxxxx
   ```

   **Contoh dengan data asli:**
   ```env
   STITCH_API_KEY=sk_1234567890abcdef1234567890abcdef
   STITCH_API_URL=https://api.stitch.tech/v1
   STITCH_AGENT_ID=agent_abc123def456
   ```

3. **Verify file `.env` tidak di-commit:**
   
   Check `.gitignore`:
   ```bash
   cat .gitignore | grep .env
   ```
   
   Harus ada line: `.env`

### Step 6: Test Configuration

#### 6.1 Run Aplikasi

```bash
flutter run
```

#### 6.2 Check Console Output

Anda harus melihat output seperti ini:

```
✓ Environment variables loaded
=== Stitch AI Configuration ===
API URL: https://api.stitch.tech/v1
Agent ID: agent_abc123def456
API Key: ✓ Set
Configured: ✓ Yes
==============================
```

**Jika melihat ini, konfigurasi Anda BERHASIL! ✅**

#### 6.3 Test Kirim Pesan

1. Aplikasi akan terbuka di emulator/device
2. Ketik pesan: "Hello"
3. Tekan tombol send
4. Tunggu response dari AI

**Jika mendapat response, integrasi BERHASIL! 🎉**

## ❌ Troubleshooting Setup

### Problem 1: Build Runner Error

**Error:**
```
[WARNING] 
Deleted previous snapshot due to missing asset graph.
Conflicting outputs were detected...
```

**Solution:**
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Problem 2: Environment Variables Not Loaded

**Error di console:**
```
⚠ Warning: Could not load .env file
```

**Checklist:**
- [ ] File `.env` ada di root project (bukan di `lib/`)
- [ ] File `.env` punya content (tidak kosong)
- [ ] File `pubspec.yaml` sudah include `.env` di assets
- [ ] Sudah run `flutter clean && flutter pub get`

**Solution:**
```bash
# Check if .env exists
ls -la | grep .env

# Check .env content
cat .env

# Restart
flutter clean
flutter pub get
flutter run
```

### Problem 3: Configuration Not Valid

**Error:**
```
=== Stitch AI Configuration ===
API URL: https://api.stitch.tech/v1
Agent ID: 
API Key: ✗ Not Set
Configured: ✗ No
==============================
```

**Solution:**

1. **Check `.env` file formatting:**
   ```env
   # WRONG ❌
   STITCH_API_KEY = "your_key"  # Ada spasi dan quotes
   
   # CORRECT ✅
   STITCH_API_KEY=your_key  # Tidak ada spasi, tidak ada quotes
   ```

2. **Ensure no trailing spaces:**
   ```env
   # WRONG ❌
   STITCH_API_KEY=your_key    # Ada spasi trailing
   
   # CORRECT ✅
   STITCH_API_KEY=your_key
   ```

3. **Restart application completely:**
   ```bash
   # Stop app (Ctrl+C or Stop button)
   flutter clean
   flutter run
   ```

### Problem 4: API Connection Failed

**Error saat send message:**
```
StitchException: HTTP 401: Unauthorized
```

**Possible causes & solutions:**

1. **API Key salah atau expired**
   - Generate API key baru di Stitch AI dashboard
   - Update `.env` dengan key baru
   - Restart app

2. **Agent ID tidak valid**
   - Verify Agent ID di Stitch AI dashboard
   - Copy exact Agent ID
   - Update `.env`
   - Restart app

3. **Network issue**
   - Check internet connection
   - Try ping: `ping api.stitch.tech`
   - Check firewall/proxy settings

### Problem 5: Flutter Doctor Issues

**If `flutter doctor` shows errors:**

```bash
# Update Flutter
flutter upgrade

# Accept Android licenses (if needed)
flutter doctor --android-licenses

# Install missing components
# Follow instructions from flutter doctor
```

## ✅ Verification Checklist

Sebelum mulai development, pastikan semua ini checked:

### Environment Setup
- [ ] Flutter SDK terinstall (`flutter --version`)
- [ ] Dart SDK terinstall (`dart --version`)
- [ ] VS Code / Android Studio dengan Flutter plugin
- [ ] Emulator atau physical device tersedia

### Project Setup
- [ ] Dependencies terinstall (`flutter pub get`)
- [ ] Generated files ada (`*.g.dart` files)
- [ ] No build errors (`flutter build apk --debug` atau `flutter run`)

### Stitch AI Setup
- [ ] Punya Stitch AI account
- [ ] API Key sudah didapat
- [ ] Agent ID sudah didapat
- [ ] File `.env` sudah dibuat dan diisi
- [ ] File `.env` tidak ter-commit (check `.gitignore`)

### Configuration Verification
- [ ] Console menampilkan "✓ Environment variables loaded"
- [ ] Console menampilkan "Configured: ✓ Yes"
- [ ] Test message berhasil dikirim dan mendapat response
- [ ] No error messages di console

## 🎓 Next Steps

Setelah setup berhasil, Anda bisa:

1. **Explore UI Features:**
   - Send messages
   - Copy messages
   - Delete messages
   - Clear chat
   - Check info dialog

2. **Modify Code:**
   - Customize UI di `lib/screens/chat_screen.dart`
   - Add features di `lib/services/`
   - Create new widgets di `lib/widgets/`

3. **Advanced Usage:**
   - Read API Reference di `README.md`
   - Implement custom request configurations
   - Add streaming responses (jika Stitch AI support)
   - Integrate with other features

## 📚 Additional Resources

- **Flutter Documentation**: https://docs.flutter.dev/
- **Stitch AI Documentation**: https://docs.stitch.tech/
- **Provider Package**: https://pub.dev/packages/provider
- **HTTP Package**: https://pub.dev/packages/http
- **JSON Serializable**: https://pub.dev/packages/json_serializable

## 🆘 Need Help?

Jika masih ada masalah setelah mengikuti guide ini:

1. **Check error messages carefully** - Biasanya sudah cukup jelas
2. **Google the error** - Banyak solusi di Stack Overflow
3. **Check Stitch AI docs** - Mungkin ada perubahan API
4. **Create issue** di repository ini dengan:
   - Error message lengkap
   - Steps yang sudah dilakukan
   - Screenshot (jika perlu)
   - Flutter doctor output

---

**Good luck! Happy coding! 🚀**
