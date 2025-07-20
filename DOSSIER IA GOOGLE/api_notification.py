from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS
from gtts import gTTS
import time
import os

app = Flask(__name__)
CORS(app)

# Dossiers pour stocker les fichiers audio et images
AUDIO_FOLDER = 'audio_files'
# IMPORTANT : Utilisez le même chemin absolu que dans votre application Streamlit
CAPTURES_FOLDER = r"C:\Users\zokou\Downloads\captures"

# Créer les dossiers s'ils n'existent pas
os.makedirs(AUDIO_FOLDER, exist_ok=True)
os.makedirs(CAPTURES_FOLDER, exist_ok=True)
print(f"Dossier audio : {os.path.abspath(AUDIO_FOLDER)}")
print(f"Dossier captures (images) : {os.path.abspath(CAPTURES_FOLDER)}")


# Route pour servir les fichiers audio
@app.route('/audio_files/<filename>')
def serve_audio(filename):
    """
    Sert les fichiers audio depuis le dossier AUDIO_FOLDER.
    """
    return send_from_directory(AUDIO_FOLDER, filename)

# Route pour servir les images capturées
@app.route('/captures/<filename>')
def serve_captures(filename):
    """
    Sert les images depuis le dossier CAPTURES_FOLDER.
    """
    return send_from_directory(CAPTURES_FOLDER, filename)

notifications = []

# Endpoint pour ajouter une notification
@app.route('/notifications/', methods=['POST'])
def add_notification():
    """
    Reçoit une notification POST, génère un fichier audio
    et stocke la notification avec l'URL de l'image.
    """
    data = request.json
    titre = data.get('titre', 'Sans titre')
    message = data.get('message', '')
    # Récupère l'image_path envoyé par Streamlit (qui est déjà l'URL complète)
    image_path_from_client = data.get('image_path', '')
    timestamp = int(time.time())

    # Génération du fichier audio avec gTTS
    try:
        tts = gTTS(text=message, lang='fr')
        filename_audio = f"notification_{timestamp}.mp3"
        filepath_audio = os.path.join(AUDIO_FOLDER, filename_audio)
        tts.save(filepath_audio)
        audio_file_url = f"http://{request.host}/audio_files/{filename_audio}"
    except Exception as e:
        print(f"Erreur lors de la génération audio : {e}")
        audio_file_url = "" # Pas d'audio si erreur

    notif = {
        'titre': titre,
        'message': message,
        'timestamp': timestamp,
        'audio_file': audio_file_url,  # URL complète pour le fichier audio
        'image_path': image_path_from_client # L'URL complète de l'image reçue de Streamlit
    }
    notifications.append(notif)
    print(f"Notification ajoutée : {notif}")
    return jsonify({"status": "ok", "notification": notif}), 201

# Endpoint pour récupérer la liste des notifications
@app.route('/notifications/', methods=['GET'])
def get_notifications():
    """
    Renvoie la liste des notifications (les plus récentes en premier).
    """
    return jsonify(list(reversed(notifications)))

if __name__ == '__main__':
    # Lance le serveur Flask sur toutes les interfaces disponibles (0.0.0.0) et le port 8000
    # debug=True permet le rechargement automatique et un débogage plus facile
    print("Démarrage du serveur Flask sur http://0.0.0.0:8000")
    app.run(host='0.0.0.0', port=8000, debug=True)

