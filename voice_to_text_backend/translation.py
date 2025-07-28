import requests
from urllib.parse import quote
from voice_to_text_backend.utils import log_error

def translate_text(text, target_lang):
    try:
        source_lang = "en"
        encoded_text = quote(text)
        url = f"https://lingva.ml/api/v1/{source_lang}/{target_lang}/{encoded_text}"

        response = requests.get(url, timeout=10)
        response.raise_for_status()

        data = response.json()
        return data.get("translation", "[Translation failed: No output]")

    except requests.RequestException as e:
        log_error(f"Translation error: {str(e)}")
        return f"[Translation failed: {str(e)}]"
    except ValueError:
        log_error("Invalid JSON returned from translation API.")
        return "[Translation failed: Invalid JSON]"
