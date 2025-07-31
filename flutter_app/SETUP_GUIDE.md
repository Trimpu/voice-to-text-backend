# Voice to Text Mobile App Setup Guide

## 🚀 Complete Setup Instructions

### Prerequisites

1. **Flutter SDK** (3.0.0 or higher)
2. **Android Studio** or **VS Code** with Flutter extensions
3. **Python Backend Server** (from the main project)

### Step 1: Backend Server Setup

1. **Start the backend server** from the main project directory:
   ```bash
   ./start_server.sh
   ```
   Or manually:
   ```bash
   source venv/bin/activate
   python app.py
   ```

2. **Find your computer's IP address**:
   - **Windows**: Open Command Prompt and run `ipconfig`
   - **Mac/Linux**: Open Terminal and run `ifconfig` or `ip addr show`
   - Look for your local IP address (usually starts with 192.168.x.x or 10.x.x.x)

### Step 2: Configure Mobile App

1. **Update server URL** in `lib/config/app_config.dart`:
   ```dart
   static const String serverUrl = 'http://YOUR_IP_ADDRESS:5000';
   ```
   Replace `YOUR_IP_ADDRESS` with your computer's IP address from Step 1.

   Example:
   ```dart
   static const String serverUrl = 'http://192.168.1.100:5000';
   ```

### Step 3: Install Dependencies

1. **Navigate to the Flutter app directory**:
   ```bash
   cd flutter_app
   ```

2. **Get Flutter dependencies**:
   ```bash
   flutter pub get
   ```

### Step 4: Run the App

#### Option A: Android Device (Recommended)

1. **Enable Developer Options** on your Android device:
   - Go to Settings > About Phone
   - Tap "Build Number" 7 times
   - Go back to Settings > Developer Options
   - Enable "USB Debugging"

2. **Connect your device** via USB

3. **Run the app**:
   ```bash
   flutter run
   ```

#### Option B: Android Emulator

1. **Create an Android emulator** in Android Studio
2. **Start the emulator**
3. **Update server URL** in `app_config.dart`:
   ```dart
   static const String serverUrl = 'http://10.0.2.2:5000';
   ```
4. **Run the app**:
   ```bash
   flutter run
   ```

## 📱 App Features

### ✅ Working Features

1. **🎙️ Voice Recording**
   - Tap the microphone button to start/stop recording
   - Real-time recording duration display
   - Automatic transcription after recording

2. **📁 File Upload**
   - Choose audio files from device storage
   - Supports: MP3, WAV, AAC, M4A, OGG, FLAC
   - Manual transcription trigger

3. **🌍 Language Translation**
   - 70+ languages supported with full names
   - Search functionality in language selector
   - Automatic translation when target language ≠ English

4. **📋 Results Display**
   - Original transcribed text
   - Translated text (if applicable)
   - Copy to clipboard functionality
   - Selectable text

5. **⚙️ Additional Features**
   - Dark/Light theme toggle
   - Error handling and user feedback
   - Loading indicators
   - Settings persistence

## 🔧 Troubleshooting

### Common Issues

#### 1. "Connection refused" or "Network error"
- **Solution**: Check if backend server is running on correct IP and port
- Verify firewall settings allow connections on port 5000
- Make sure both devices are on the same network

#### 2. "Microphone permission denied"
- **Solution**: Grant microphone permission in Android settings
- Go to Settings > Apps > Voice to Text > Permissions > Microphone

#### 3. "No audio recorded" or empty transcription
- **Solution**: 
  - Check microphone is working
  - Ensure sufficient recording duration (minimum 1 second)
  - Verify audio file format is supported

#### 4. Translation not working
- **Solution**:
  - Check internet connection
  - Verify backend server can access translation API
  - Try different target language

#### 5. File upload fails
- **Solution**:
  - Check file size (max 25MB)
  - Verify file format is supported
  - Grant storage permissions if needed

### Debug Mode

To run in debug mode with detailed logs:
```bash
flutter run --debug
```

Check logs for detailed error information.

## 🔧 Configuration Options

### Server Configuration (`lib/config/app_config.dart`)

```dart
// Change server URL
static const String serverUrl = 'http://YOUR_IP:5000';

// Recording limits
static const int maxRecordingDuration = 300; // 5 minutes
static const int minRecordingDuration = 1;   // 1 second

// File size limit
static const int maxFileSizeMB = 25;

// Supported formats
static const List<String> supportedAudioFormats = [
  'mp3', 'wav', 'aac', 'm4a', 'ogg', 'flac'
];
```

## 📚 Usage Instructions

### Recording Voice

1. **Select target language** (optional, defaults to English)
2. **Tap the microphone button** to start recording
3. **Speak clearly** into the device microphone
4. **Tap the stop button** to end recording
5. **Wait for transcription** to complete
6. **View results** in the results card below

### Uploading Audio Files

1. **Select target language** (optional)
2. **Tap "Choose Audio File"**
3. **Select an audio file** from your device
4. **Tap "Transcribe"** to process the file
5. **Wait for results**

### Language Selection

1. **Tap the language selector** card
2. **Search for your desired language** (supports 70+ languages)
3. **Tap to select** the language
4. **The selection is saved** for future use

### Copying Results

1. **Tap the copy icon** next to any text result
2. **Text is copied** to clipboard
3. **Paste anywhere** you need the text

## 🏗️ Development

### Project Structure

```
flutter_app/
├── lib/
│   ├── config/          # App configuration
│   ├── models/          # Data models
│   ├── providers/       # State management
│   ├── screens/         # UI screens
│   ├── services/        # API and audio services
│   ├── utils/           # Utilities and themes
│   ├── widgets/         # Reusable UI components
│   └── main.dart        # App entry point
├── android/             # Android-specific files
├── pubspec.yaml         # Dependencies
└── SETUP_GUIDE.md       # This file
```

### Key Components

- **ApiService**: Handles backend communication
- **AudioService**: Manages recording and playback
- **AppState**: Global state management
- **LanguageList**: Comprehensive language support

## 🤝 Support

If you encounter any issues:

1. **Check this guide** for common solutions
2. **Verify backend server** is running correctly
3. **Check device permissions** (microphone, storage)
4. **Ensure network connectivity** between devices
5. **Review app logs** for detailed error information

## 🔄 Updates

To update the app:

1. **Pull latest changes** from repository
2. **Run `flutter pub get`** to update dependencies
3. **Restart the app** with `flutter run`

---

**Note**: Make sure your mobile device and computer running the backend server are connected to the same Wi-Fi network for the app to work properly.