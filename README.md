# Stitch AI Flutter Integration

Aplikasi Flutter dengan integrasi Stitch AI untuk chat dengan AI assistant.

## 📋 Daftar Isi

- [Fitur](#fitur)
- [Persyaratan](#persyaratan)
- [Instalasi](#instalasi)
- [Konfigurasi](#konfigurasi)
- [Cara Menggunakan](#cara-menggunakan)
- [Struktur Project](#struktur-project)
- [API Reference](#api-reference)
- [Troubleshooting](#troubleshooting)

## ✨ Fitur

- ✅ Chat dengan Stitch AI assistant
- ✅ History percakapan
- ✅ Copy & delete individual messages
- ✅ Clear all chat
- ✅ Error handling yang comprehensive
- ✅ Loading states
- ✅ Dark mode support
- ✅ Material 3 design
- ✅ Responsive UI

## 📦 Persyaratan

- Flutter SDK: `>=3.0.0 <4.0.0`
- Dart SDK: `>=3.0.0`
- Stitch AI account & API key
- Agent ID dari Stitch AI

## 🚀 Instalasi

### Step 1: Clone atau Download Project

```bash
# Jika menggunakan git
git clone <repository-url>
cd aplikasinognkrong
```

### Step 2: Install Dependencies

```bash
flutter pub get
```

### Step 3: Generate Code untuk JSON Serialization

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

> **Catatan**: Command ini akan generate file `.g.dart` untuk semua model classes.

## ⚙️ Konfigurasi

### Step 1: Dapatkan Credentials dari Stitch AI

1. Login ke [Stitch AI Dashboard](https://stitch.tech/)
2. Buat atau pilih agent yang ingin digunakan
3. Copy **API Key** dan **Agent ID**

### Step 2: Setup Environment Variables

1. Copy file `.env.example` menjadi `.env`:
   ```bash
   cp .env.example .env
   ```

2. Edit file `.env` dan isi dengan credentials Anda:
   ```env
   STITCH_API_KEY=your_actual_api_key_here
   STITCH_API_URL=https://api.stitch.tech/v1
   STITCH_AGENT_ID=your_actual_agent_id_here
   ```

> **⚠️ PENTING**: 
> - Jangan commit file `.env` ke git (sudah ada di `.gitignore`)
> - Ganti `your_actual_api_key_here` dengan API key asli Anda
> - Ganti `your_actual_agent_id_here` dengan Agent ID asli Anda

### Step 3: Verifikasi Konfigurasi

Jalankan aplikasi dan periksa console output. Anda akan melihat:

```
✓ Environment variables loaded
=== Stitch AI Configuration ===
API URL: https://api.stitch.tech/v1
Agent ID: your_agent_id
API Key: ✓ Set
Configured: ✓ Yes
==============================
```

## 🎯 Cara Menggunakan

### Menjalankan Aplikasi

```bash
flutter run
```

### Menggunakan Chat Interface

1. **Kirim Pesan**: Ketik pesan di input field dan tekan tombol send
2. **Copy Pesan**: Long press pada message bubble → pilih "Copy"
3. **Delete Pesan**: Long press pada message bubble → pilih "Delete"
4. **Clear Chat**: Tap icon delete di app bar → confirm
5. **Info**: Tap icon info di app bar untuk melihat informasi aplikasi

### Menggunakan API Service Secara Programmatic

```dart
import 'package:aplikasinognkrong/services/stitch_api_service.dart';
import 'package:aplikasinognkrong/models/stitch_request.dart';

// Initialize service
final service = StitchApiService();

// Send simple message
try {
  final response = await service.sendSimpleMessage('Hello, AI!');
  print('Response: $response');
} catch (e) {
  print('Error: $e');
}

// Send dengan custom configuration
final request = StitchRequest(
  agentId: 'your_agent_id',
  messages: [
    StitchMessage.user('What is Flutter?'),
  ],
  temperature: 0.7,
  maxTokens: 500,
);

final response = await service.sendMessage(request);
print('AI Response: ${response.content}');
```

### Menggunakan Provider untuk State Management

```dart
import 'package:provider/provider.dart';
import 'package:aplikasinognkrong/services/stitch_chat_provider.dart';

// Di widget
final provider = context.read<StitchChatProvider>();

// Send message
await provider.sendMessage('Hello AI!');

// Access messages
final messages = provider.messages;

// Check loading state
if (provider.isLoading) {
  // Show loading indicator
}

// Check error
if (provider.error != null) {
  // Show error message
}
```

## 📁 Struktur Project

```
lib/
├── config/
│   └── app_config.dart          # Konfigurasi aplikasi & environment variables
├── models/
│   ├── stitch_message.dart      # Model untuk chat messages
│   ├── stitch_request.dart      # Model untuk API request
│   ├── stitch_response.dart     # Model untuk API response
│   └── stitch_error.dart        # Model untuk error handling
├── services/
│   ├── stitch_api_service.dart  # HTTP client & API calls
│   └── stitch_chat_provider.dart # State management dengan Provider
├── screens/
│   └── chat_screen.dart         # Main chat screen
├── widgets/
│   ├── message_bubble.dart      # Message bubble component
│   └── message_input.dart       # Message input field component
└── main.dart                    # Entry point aplikasi
```

## 📚 API Reference

### StitchApiService

#### Methods

**`sendMessage(StitchRequest request)`**
- Send message dengan full configuration
- Returns: `Future<StitchResponse>`
- Throws: `StitchException` on error

**`sendSimpleMessage(String message, {String? agentId})`**
- Send simple text message
- Returns: `Future<String>`
- Throws: `StitchException` on error

**`sendConversation(List<StitchMessage> messages, {...})`**
- Send conversation dengan multiple messages
- Returns: `Future<StitchResponse>`
- Throws: `StitchException` on error

**`testConnection()`**
- Test koneksi ke Stitch AI API
- Returns: `Future<bool>`

### StitchChatProvider

#### Properties

- `messages`: List of `StitchMessage`
- `isLoading`: Boolean loading state
- `error`: String? error message
- `hasMessages`: Boolean check if has messages

#### Methods

- `sendMessage(String content)`: Send user message
- `clearMessages()`: Clear all messages
- `removeMessage(int index)`: Remove specific message
- `clearError()`: Clear error state
- `testConnection()`: Test API connection

## 🔧 Troubleshooting

### Error: "Environment variables not loaded"

**Solusi:**
- Pastikan file `.env` ada di root project
- Pastikan file `.env` berisi konfigurasi yang benar
- Restart aplikasi

### Error: "Stitch AI belum dikonfigurasi"

**Solusi:**
- Check file `.env` sudah diisi dengan API key dan Agent ID yang benar
- Pastikan tidak ada typo di nama environment variables
- Run `flutter clean` lalu `flutter pub get`

### Error: "HTTP 401 Unauthorized"

**Solusi:**
- API key Anda salah atau expired
- Generate API key baru dari Stitch AI dashboard
- Update file `.env` dengan API key baru

### Error: "HTTP 404 Not Found"

**Solusi:**
- Agent ID tidak valid atau tidak ditemukan
- Cek Agent ID di Stitch AI dashboard
- Update `STITCH_AGENT_ID` di file `.env`

### Error: "Connection timeout"

**Solusi:**
- Check koneksi internet
- Pastikan API URL benar di `.env`
- Coba test connection: `provider.testConnection()`

### Build Runner Error

**Solusi:**
```bash
# Clean build cache
flutter clean

# Delete conflicting outputs
flutter pub run build_runner build --delete-conflicting-outputs

# Get dependencies again
flutter pub get
```

### Model Generation Issues

Jika ada error terkait `.g.dart` files:

```bash
# Delete generated files
find . -name "*.g.dart" -delete

# Regenerate
flutter pub run build_runner build --delete-conflicting-outputs
```

## 🧪 Testing

### Manual Testing

1. Run aplikasi
2. Send test message: "Hello"
3. Verify response dari AI
4. Test error handling dengan invalid API key
5. Test UI interactions (copy, delete, clear)

### Test Connection

```dart
final provider = StitchChatProvider();
final isConnected = await provider.testConnection();
print('Connection status: $isConnected');
```

## 📱 Build untuk Production

### Android

```bash
flutter build apk --release
# atau
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release
```

> **Catatan**: Pastikan file `.env` tidak ter-bundle ke production build. Untuk production, gunakan environment variables yang proper atau secure storage.

## 🔐 Security Best Practices

1. **Jangan commit `.env` ke repository**
   - Sudah ada di `.gitignore`
   - Gunakan `.env.example` sebagai template

2. **API Key Management**
   - Untuk production, gunakan secure storage
   - Jangan hardcode API keys di source code
   - Rotate API keys secara berkala

3. **Environment Variables**
   - Development: `.env` file
   - Production: Server-side environment variables atau secure vault

## 📝 Notes

- Project ini menggunakan `json_serializable` untuk JSON serialization
- State management menggunakan `provider` package
- HTTP client menggunakan `http` package
- Environment variables menggunakan `flutter_dotenv`

## 🤝 Kontribusi

Jika ingin berkontribusi:

1. Fork repository
2. Buat feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

## 📄 License

Project ini dibuat untuk keperluan integrasi Stitch AI dengan Flutter.

## 🆘 Support

Jika ada pertanyaan atau issue:
- Check [Stitch AI Documentation](https://docs.stitch.tech/)
- Open issue di repository ini
- Contact Stitch AI support

---

**Selamat mencoba! 🚀**