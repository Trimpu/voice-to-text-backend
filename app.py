from flask import Flask, request, jsonify
from flask_cors import CORS

# ✅ Use relative imports only if this file is inside the package folder
from voice_to_text_backend.transcription import transcribe_audio
from voice_to_text_backend.translation import translate_text
from voice_to_text_backend.utils import log_error


import tempfile
import os

app = Flask(__name__)
# Enable CORS for all routes and origins (for mobile app)
CORS(app, origins="*", allow_headers=["Content-Type", "Authorization"], methods=["GET", "POST", "OPTIONS"])

@app.route("/transcribe", methods=["POST"])
def transcribe_route():
    try:
        print(f"Received transcribe request from {request.remote_addr}")
        
        if "file" not in request.files:
            print("Error: No file uploaded")
            return jsonify({"error": "No file uploaded"}), 400

        file = request.files["file"]
        if file.filename == "":
            print("Error: Empty filename")
            return jsonify({"error": "Empty filename"}), 400

        target_lang = request.form.get("lang", "en")
        print(f"Target language: {target_lang}")
        print(f"File: {file.filename}, Size: {len(file.read())} bytes")
        file.seek(0)  # Reset file pointer after reading size

        # Save uploaded file
        file_extension = os.path.splitext(file.filename)[1] or ".mp3"
        with tempfile.NamedTemporaryFile(delete=False, suffix=file_extension) as temp_audio:
            file.save(temp_audio.name)
            print(f"Saved file to: {temp_audio.name}")

        # Transcribe audio
        print("Starting transcription...")
        original_text = transcribe_audio(temp_audio.name)
        print(f"Transcription result: {original_text[:100]}...")
        
        # Clean up temp file
        os.unlink(temp_audio.name)

        # Translate if needed
        if target_lang != "en" and original_text.strip():
            print(f"Translating to {target_lang}...")
            translated_text = translate_text(original_text, target_lang)
            print(f"Translation result: {translated_text[:100]}...")
        else:
            translated_text = original_text

        response_data = {
            "original_text": original_text,
            "translated_text": translated_text,
            "language": target_lang,
            "status": "success"
        }
        
        print("Request completed successfully")
        return jsonify(response_data)
        
    except Exception as e:
        error_msg = str(e)
        print(f"Error processing request: {error_msg}")
        log_error(error_msg)
        
        # Clean up temp file if it exists
        try:
            if 'temp_audio' in locals():
                os.unlink(temp_audio.name)
        except:
            pass
            
        return jsonify({
            "error": "Server error occurred", 
            "details": error_msg
        }), 500

@app.route("/health", methods=["GET"])
def health_check():
    return jsonify({"status": "healthy", "message": "Voice-to-text API is running"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", 5000)))

