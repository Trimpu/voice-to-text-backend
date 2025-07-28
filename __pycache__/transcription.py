import whisper

# Load Whisper model once globally
model = whisper.load_model("base")

def transcribe_audio(file_path):
    try:
        result = model.transcribe(file_path, task="transcribe")
        return result.get("text", "")
    except Exception as e:
        raise RuntimeError(f"Whisper transcription failed: {str(e)}")
