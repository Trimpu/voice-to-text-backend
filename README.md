# Voice-to-Text Application

A complete voice-to-text solution with Flask backend API and Flutter mobile app. Converts audio files to text using OpenAI's Whisper model and provides translation services for 70+ languages.

## Features

### Backend API
- 🎙️ **Audio Transcription**: Convert audio files to text using OpenAI Whisper
- 🌍 **Translation**: Translate transcribed text to 70+ languages
- 🔄 **Multiple Audio Formats**: Supports MP3, WAV, AAC, M4A, OGG, FLAC
- 🚀 **REST API**: Simple HTTP endpoints for easy integration
- 🐳 **Cross-platform**: Works on Linux, macOS, and Windows

### Mobile App
- 📱 **Flutter Mobile App**: Native Android app with modern UI
- 🎤 **Voice Recording**: Real-time audio recording with visual feedback
- 📁 **File Upload**: Choose and upload audio files from device storage
- 🌐 **70+ Languages**: Full language names with search functionality
- 📋 **Results Management**: Copy transcriptions and translations to clipboard
- 🌙 **Dark/Light Theme**: Automatic theme switching with user preference
- ⚡ **Real-time Processing**: Live transcription and translation

## Quick Start

### Backend Server Setup

#### Prerequisites

- Python 3.8 or higher
- pip (Python package manager)
- ffmpeg (for audio processing)

#### Installation

1. **Clone or navigate to the project directory**
2. **Run the setup script**:
   ```bash
   ./start_server.sh
   ```
   This will automatically:
   - Create a virtual environment
   - Install all dependencies
   - Start the server

### Mobile App Setup

1. **Follow the detailed setup guide**: [Flutter App Setup Guide](flutter_app/SETUP_GUIDE.md)
2. **Key steps**:
   - Install Flutter SDK
   - Configure server IP address in `flutter_app/lib/config/app_config.dart`
   - Run `flutter pub get` to install dependencies
   - Connect Android device or start emulator
   - Run `flutter run` to launch the app

### Manual Setup

If you prefer to set up manually:

1. **Create a virtual environment**:
   ```bash
   python3 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

2. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

3. **Start the server**:
   ```bash
   python app.py
   ```

## Usage

### API Endpoint

**POST** `/transcribe`

### Parameters

- `file` (required): Audio file to transcribe
- `lang` (optional): Target language for translation (default: "en")

### Example Requests

#### Basic Transcription (English)
```bash
curl -X POST \
  -F 'file=@your_audio.mp3' \
  http://localhost:5000/transcribe
```

#### Transcription with Translation
```bash
curl -X POST \
  -F 'file=@your_audio.mp3' \
  -F 'lang=es' \
  http://localhost:5000/transcribe
```

### Response Format

```json
{
  "original_text": "Hello, this is a test recording.",
  "translated_text": "Hola, esta es una grabación de prueba.",
  "language": "es",
  "status": "success"
}
```

### Error Response

```json
{
  "error": "Error description",
  "details": "Detailed error information"
}
```

## Supported Languages

The translation service supports many languages including:
- Spanish (es)
- French (fr)
- German (de)
- Italian (it)
- Portuguese (pt)
- Chinese (zh)
- Japanese (ja)
- Korean (ko)
- And many more...

## Project Structure

```
voice-to-text-backend/
├── app.py                 # Main Flask application
├── requirements.txt       # Python dependencies
├── start_server.sh       # Startup script
├── test_app.py           # Test script
├── voice_to_text_backend/
│   ├── __init__.py
│   ├── transcription.py  # Whisper integration
│   ├── translation.py    # Translation service
│   └── utils.py          # Utility functions
└── README.md             # This file
```

## Dependencies

- **Flask**: Web framework
- **flask-cors**: Cross-origin resource sharing
- **openai-whisper**: Audio transcription
- **requests**: HTTP client for translation API
- **torch**: PyTorch (Whisper dependency)

## Testing

Run the test suite to verify everything is working:

```bash
source venv/bin/activate
python test_app.py
```

## Configuration

### Environment Variables

- `PORT`: Server port (default: 5000)

### Whisper Model

The application uses the "base" Whisper model by default. You can modify this in `voice_to_text_backend/transcription.py`:

```python
model = whisper.load_model("base")  # Options: tiny, base, small, medium, large
```

## Troubleshooting

### Common Issues

1. **ffmpeg not found**:
   ```bash
   # Ubuntu/Debian
   sudo apt install ffmpeg
   
   # macOS
   brew install ffmpeg
   
   # Windows
   # Download from https://ffmpeg.org/download.html
   ```

2. **CUDA/GPU issues**:
   The application will automatically fall back to CPU if CUDA is not available.

3. **Memory issues**:
   If you encounter memory issues, try using a smaller Whisper model:
   ```python
   model = whisper.load_model("tiny")  # Uses less memory
   ```

### Logs

Error logs are printed to the console. For production deployment, consider setting up proper logging.

## Performance

- **First request**: May take longer due to model loading
- **Subsequent requests**: Faster as the model stays in memory
- **File size**: Larger files take longer to process
- **Model size**: Larger models are more accurate but slower

## Production Deployment

For production use, consider:

1. **Use a production WSGI server** (e.g., Gunicorn):
   ```bash
   pip install gunicorn
   gunicorn -w 4 -b 0.0.0.0:5000 app:app
   ```

2. **Set up reverse proxy** (nginx, Apache)
3. **Configure proper logging**
4. **Set up monitoring**
5. **Use environment variables for configuration**

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## Support

If you encounter any issues or have questions, please check the troubleshooting section or create an issue in the repository.