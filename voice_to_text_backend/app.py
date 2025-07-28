from flask import Flask, request, jsonify
from flask_cors import CORS

# ✅ Use relative imports only if this file is inside the package folder
from voice_to_text_backend.transcription import transcribe_audio
from voice_to_text_backend.translation import translate_text
from voice_to_text_backend.utils import log_error


import tempfile
import os

app = Flask(__name__)
CORS(app)

@app.route("/transcribe", methods=["POST"])
def transcribe_route():
    if "file" not in request.files:
        return jsonify({"error": "No file uploaded"}), 400

    file = request.files["file"]
    if file.filename == "":
        return jsonify({"error": "Empty filename"}), 400

    target_lang = request.form.get("lang", "en")

    try:
        with tempfile.NamedTemporaryFile(delete=False, suffix=".mp3") as temp_audio:
            file.save(temp_audio.name)

        original_text = transcribe_audio(temp_audio.name)
        os.unlink(temp_audio.name)

        if target_lang != "en":
            translated_text = translate_text(original_text, target_lang)
        else:
            translated_text = original_text

        return jsonify({
            "original_text": original_text,
            "translated_text": translated_text,
            "language": target_lang,
            "status": "success"
        })
    except Exception as e:
        log_error(str(e))
        return jsonify({"error": "Server error occurred", "details": str(e)}), 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
