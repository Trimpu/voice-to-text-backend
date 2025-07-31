#!/bin/bash

# Voice-to-Text Server Startup Script
echo "🎙️  Starting Voice-to-Text Server..."
echo "=================================="

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "❌ Virtual environment not found. Please run setup first."
    exit 1
fi

# Activate virtual environment
source venv/bin/activate

# Check if dependencies are installed
python -c "import flask, flask_cors, requests, whisper" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "❌ Dependencies not installed. Installing now..."
    pip install -r requirements.txt
fi

echo "✅ Dependencies verified"
echo "🚀 Starting Flask server..."
echo ""
echo "Server will be available at: http://localhost:5000"
echo "Endpoint: POST /transcribe"
echo ""
echo "To test with curl:"
echo "curl -X POST -F 'file=@your_audio.mp3' -F 'lang=en' http://localhost:5000/transcribe"
echo ""
echo "Press Ctrl+C to stop the server"
echo "=================================="

# Start the server
python app.py