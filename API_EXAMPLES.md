# 🔌 API Examples & Code Snippets

Kumpulan contoh kode untuk menggunakan Stitch AI API di Flutter.

## 📚 Table of Contents

- [Basic Usage](#basic-usage)
- [Advanced Usage](#advanced-usage)
- [Provider Usage](#provider-usage)
- [Error Handling](#error-handling)
- [Custom Widgets](#custom-widgets)

---

## Basic Usage

### 1. Send Simple Message

```dart
import 'package:aplikasinognkrong/services/stitch_api_service.dart';

void sendSimpleMessage() async {
  final service = StitchApiService();
  
  try {
    final response = await service.sendSimpleMessage('Hello, AI!');
    print('AI Response: $response');
  } catch (e) {
    print('Error: $e');
  }
}
```

### 2. Send Message dengan Agent ID Custom

```dart
void sendMessageToCustomAgent() async {
  final service = StitchApiService();
  
  try {
    final response = await service.sendSimpleMessage(
      'Tell me about Flutter',
      agentId: 'agent_custom_123',
    );
    print('Response: $response');
  } catch (e) {
    print('Error: $e');
  }
}
```

### 3. Test Connection

```dart
void testConnection() async {
  final service = StitchApiService();
  
  final isConnected = await service.testConnection();
  
  if (isConnected) {
    print('✓ Connected to Stitch AI');
  } else {
    print('✗ Connection failed');
  }
}
```

---

## Advanced Usage

### 1. Send with Full Configuration

```dart
import 'package:aplikasinognkrong/services/stitch_api_service.dart';
import 'package:aplikasinognkrong/models/stitch_request.dart';
import 'package:aplikasinognkrong/models/stitch_message.dart';

void sendAdvancedMessage() async {
  final service = StitchApiService();
  
  final request = StitchRequest(
    agentId: 'your_agent_id',
    messages: [
      StitchMessage.system('You are a helpful Flutter expert.'),
      StitchMessage.user('How do I use Provider in Flutter?'),
    ],
    temperature: 0.7,
    maxTokens: 500,
  );
  
  try {
    final response = await service.sendMessage(request);
    
    print('Response ID: ${response.id}');
    print('Model: ${response.model}');
    print('Content: ${response.content}');
    print('Finish Reason: ${response.finishReason}');
    
    if (response.usage != null) {
      print('Tokens Used: ${response.usage!.totalTokens}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
```

### 2. Send Conversation History

```dart
void sendConversation() async {
  final service = StitchApiService();
  
  final messages = [
    StitchMessage.user('What is Flutter?'),
    StitchMessage.assistant('Flutter is a UI framework by Google.'),
    StitchMessage.user('Tell me more about widgets.'),
  ];
  
  try {
    final response = await service.sendConversation(
      messages,
      temperature: 0.8,
      maxTokens: 1000,
    );
    
    print('AI: ${response.content}');
  } catch (e) {
    print('Error: $e');
  }
}
```

### 3. Custom Metadata

```dart
void sendWithMetadata() async {
  final service = StitchApiService();
  
  final request = StitchRequest(
    agentId: 'your_agent_id',
    messages: [
      StitchMessage.user('Hello'),
    ],
    metadata: {
      'user_id': '123',
      'session_id': 'abc-def-ghi',
      'app_version': '1.0.0',
    },
  );
  
  try {
    final response = await service.sendMessage(request);
    print('Response: ${response.content}');
  } catch (e) {
    print('Error: $e');
  }
}
```

---

## Provider Usage

### 1. Setup Provider in Widget

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aplikasinognkrong/services/stitch_chat_provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StitchChatProvider(),
      child: MaterialApp(
        home: ChatScreen(),
      ),
    );
  }
}
```

### 2. Send Message via Provider

```dart
class ChatWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Send message
        context.read<StitchChatProvider>().sendMessage('Hello AI!');
      },
      child: Text('Send Message'),
    );
  }
}
```

### 3. Listen to Messages

```dart
class MessageList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<StitchChatProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return CircularProgressIndicator();
        }
        
        if (provider.error != null) {
          return Text('Error: ${provider.error}');
        }
        
        return ListView.builder(
          itemCount: provider.messages.length,
          itemBuilder: (context, index) {
            final message = provider.messages[index];
            return ListTile(
              title: Text(message.role),
              subtitle: Text(message.content),
            );
          },
        );
      },
    );
  }
}
```

### 4. Advanced Provider Usage

```dart
class AdvancedChatWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StitchChatProvider>();
    
    return Column(
      children: [
        // Show message count
        Text('Messages: ${provider.messages.length}'),
        
        // Show loading state
        if (provider.isLoading)
          LinearProgressIndicator(),
        
        // Show error
        if (provider.error != null)
          ErrorBanner(message: provider.error!),
        
        // Send button
        ElevatedButton(
          onPressed: provider.isLoading ? null : () async {
            final response = await provider.sendMessageAdvanced(
              content: 'Advanced message',
              temperature: 0.9,
              maxTokens: 200,
            );
            
            if (response != null) {
              print('Tokens: ${response.usage?.totalTokens}');
            }
          },
          child: Text('Send Advanced'),
        ),
        
        // Clear button
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: provider.clearMessages,
        ),
      ],
    );
  }
}
```

---

## Error Handling

### 1. Try-Catch Pattern

```dart
void handleErrors() async {
  final service = StitchApiService();
  
  try {
    final response = await service.sendSimpleMessage('Hello');
    print('Success: $response');
  } on StitchException catch (e) {
    // Handle Stitch-specific errors
    print('Stitch Error: ${e.message}');
    print('Status Code: ${e.statusCode}');
    
    if (e.error != null) {
      print('Error Type: ${e.error!.type}');
      print('Error Code: ${e.error!.code}');
    }
  } catch (e) {
    // Handle general errors
    print('General Error: $e');
  }
}
```

### 2. Status Code Handling

```dart
void handleStatusCodes() async {
  final service = StitchApiService();
  
  try {
    await service.sendSimpleMessage('Hello');
  } on StitchException catch (e) {
    switch (e.statusCode) {
      case 401:
        print('Unauthorized: Check your API key');
        break;
      case 404:
        print('Not Found: Check your Agent ID');
        break;
      case 429:
        print('Rate Limited: Too many requests');
        break;
      case 500:
        print('Server Error: Try again later');
        break;
      default:
        print('Error ${e.statusCode}: ${e.message}');
    }
  }
}
```

### 3. Error UI Display

```dart
class ErrorDisplay extends StatelessWidget {
  final String? error;
  final VoidCallback onRetry;
  
  @override
  Widget build(BuildContext context) {
    if (error == null) return SizedBox.shrink();
    
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.red[100],
      child: Row(
        children: [
          Icon(Icons.error, color: Colors.red),
          SizedBox(width: 8),
          Expanded(child: Text(error!)),
          TextButton(
            onPressed: onRetry,
            child: Text('RETRY'),
          ),
        ],
      ),
    );
  }
}
```

---

## Custom Widgets

### 1. Loading Indicator

```dart
class StitchLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<StitchChatProvider>(
      builder: (context, provider, _) {
        if (!provider.isLoading) return SizedBox.shrink();
        
        return Container(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 12),
              Text('AI is typing...'),
            ],
          ),
        );
      },
    );
  }
}
```

### 2. Message Counter

```dart
class MessageCounter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<StitchChatProvider>(
      builder: (context, provider, _) {
        return Chip(
          avatar: Icon(Icons.chat, size: 16),
          label: Text('${provider.messages.length} messages'),
        );
      },
    );
  }
}
```

### 3. Connection Status

```dart
class ConnectionStatus extends StatefulWidget {
  @override
  _ConnectionStatusState createState() => _ConnectionStatusState();
}

class _ConnectionStatusState extends State<ConnectionStatus> {
  bool? _isConnected;
  
  @override
  void initState() {
    super.initState();
    _checkConnection();
  }
  
  void _checkConnection() async {
    final provider = context.read<StitchChatProvider>();
    final connected = await provider.testConnection();
    setState(() {
      _isConnected = connected;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isConnected == null) {
      return CircularProgressIndicator();
    }
    
    return Row(
      children: [
        Icon(
          _isConnected! ? Icons.check_circle : Icons.error,
          color: _isConnected! ? Colors.green : Colors.red,
        ),
        SizedBox(width: 8),
        Text(_isConnected! ? 'Connected' : 'Disconnected'),
      ],
    );
  }
}
```

---

## Complete Example App

### Full Working Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:aplikasinognkrong/services/stitch_chat_provider.dart';
import 'package:aplikasinognkrong/models/stitch_message.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StitchChatProvider(),
      child: MaterialApp(
        home: SimpleChatScreen(),
      ),
    );
  }
}

class SimpleChatScreen extends StatefulWidget {
  @override
  _SimpleChatScreenState createState() => _SimpleChatScreenState();
}

class _SimpleChatScreenState extends State<SimpleChatScreen> {
  final _controller = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StitchChatProvider>();
    
    return Scaffold(
      appBar: AppBar(title: Text('Simple Chat')),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: ListView.builder(
              itemCount: provider.messages.length,
              itemBuilder: (context, index) {
                final msg = provider.messages[index];
                return ListTile(
                  leading: Icon(
                    msg.role == 'user' ? Icons.person : Icons.smart_toy,
                  ),
                  title: Text(msg.content),
                );
              },
            ),
          ),
          
          // Loading
          if (provider.isLoading)
            LinearProgressIndicator(),
          
          // Error
          if (provider.error != null)
            Container(
              color: Colors.red[100],
              padding: EdgeInsets.all(8),
              child: Text(provider.error!),
            ),
          
          // Input
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    provider.sendMessage(_controller.text);
                    _controller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## Tips & Best Practices

### 1. Dispose Service Properly

```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late StitchApiService _service;
  
  @override
  void initState() {
    super.initState();
    _service = StitchApiService();
  }
  
  @override
  void dispose() {
    _service.dispose(); // Important!
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

### 2. Debounce Requests

```dart
import 'dart:async';

class DebouncedChat extends StatefulWidget {
  @override
  _DebouncedChatState createState() => _DebouncedChatState();
}

class _DebouncedChatState extends State<DebouncedChat> {
  Timer? _debounce;
  
  void _onTextChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    _debounce = Timer(Duration(milliseconds: 500), () {
      // Send message after user stops typing
      context.read<StitchChatProvider>().sendMessage(text);
    });
  }
  
  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: _onTextChanged,
    );
  }
}
```

### 3. Retry Logic

```dart
Future<String?> sendWithRetry(String message, {int maxRetries = 3}) async {
  final service = StitchApiService();
  
  for (int i = 0; i < maxRetries; i++) {
    try {
      return await service.sendSimpleMessage(message);
    } catch (e) {
      if (i == maxRetries - 1) rethrow;
      await Future.delayed(Duration(seconds: 2 * (i + 1)));
    }
  }
  
  return null;
}
```

---

**Happy coding! 🚀**
