#!/usr/bin/env python3
"""
Exemple de serveur Flask pour tester le système de notifications vocales
Ce serveur génère des notifications de test avec des fichiers audio simulés.
"""

from flask import Flask, jsonify, send_file
from flask_cors import CORS
import time
import os
import random

app = Flask(__name__)
CORS(app)  # Permettre les requêtes cross-origin depuis Flutter

# Données de test
NOTIFICATION_EXAMPLES = [
    {
        "titre": "Analyse automatique",
        "message": "Votre plantation de tomates présente un excellent état de santé.",
    },
    {
        "titre": "Alerte ravageurs",
        "message": "Détection de pucerons sur la parcelle nord. Intervention recommandée.",
    },
    {
        "titre": "Optimisation irrigation",
        "message": "Le sol de la zone sud nécessite un arrosage dans les 2 prochaines heures.",
    },
    {
        "titre": "Météo favorable",
        "message": "Conditions optimales pour la plantation prévues demain matin.",
    },
    {
        "titre": "Récolte recommandée",
        "message": "Les tomates de la parcelle est ont atteint leur maturité optimale.",
    }
]

# Stockage temporaire des notifications générées
generated_notifications = []

@app.route('/notifications/', methods=['GET'])
def get_notifications():
    """
    Endpoint principal pour récupérer les notifications
    Génère occasionnellement de nouvelles notifications pour le test
    """
    global generated_notifications
    
    # Générer une nouvelle notification aléatoirement (20% de chance)
    if random.random() < 0.2:
        generate_new_notification()
    
    return jsonify(generated_notifications)

@app.route('/audio_files/<filename>', methods=['GET'])
def get_audio_file(filename):
    """
    Sert les fichiers audio (simulés pour le test)
    En production, ceci devrait servir de vrais fichiers MP3
    """
    # Pour le test, on retourne un fichier audio vide ou un placeholder
    # En production, remplacez ceci par le vrai fichier audio
    try:
        # Créer un fichier audio de test s'il n'existe pas
        audio_dir = 'audio_files'
        if not os.path.exists(audio_dir):
            os.makedirs(audio_dir)
        
        file_path = os.path.join(audio_dir, filename)
        if not os.path.exists(file_path):
            # Créer un fichier audio de test vide
            with open(file_path, 'wb') as f:
                f.write(b'')  # Fichier vide pour le test
        
        return send_file(file_path, mimetype='audio/mpeg')
    except Exception as e:
        return jsonify({"error": f"Fichier audio non trouvé: {filename}"}), 404

@app.route('/generate_notification', methods=['POST'])
def generate_notification_manual():
    """
    Endpoint pour générer manuellement une notification (utile pour les tests)
    """
    generate_new_notification()
    return jsonify({"message": "Nouvelle notification générée"})

@app.route('/clear_notifications', methods=['POST'])
def clear_notifications():
    """
    Vide toutes les notifications (utile pour les tests)
    """
    global generated_notifications
    generated_notifications = []
    return jsonify({"message": "Notifications effacées"})

@app.route('/status', methods=['GET'])
def get_status():
    """
    Endpoint de statut pour vérifier que le serveur fonctionne
    """
    return jsonify({
        "status": "running",
        "notifications_count": len(generated_notifications),
        "timestamp": int(time.time())
    })

def generate_new_notification():
    """
    Génère une nouvelle notification avec un timestamp unique
    """
    global generated_notifications
    
    # Choisir un exemple aléatoire
    example = random.choice(NOTIFICATION_EXAMPLES)
    
    # Créer la notification avec timestamp unique
    timestamp = int(time.time()) + random.randint(0, 10)  # Éviter les doublons
    audio_filename = f"notification_{timestamp}.mp3"
    
    notification = {
        "audio_file": f"audio_files/{audio_filename}",
        "message": example["message"],
        "timestamp": timestamp,
        "titre": example["titre"]
    }
    
    # Ajouter à la liste (garder seulement les 10 dernières)
    generated_notifications.append(notification)
    if len(generated_notifications) > 10:
        generated_notifications.pop(0)
    
    print(f"📢 Nouvelle notification générée: {example['titre']}")

@app.route('/', methods=['GET'])
def index():
    """
    Page d'accueil avec informations sur l'API
    """
    return """
    <h1>🔊 Serveur de Notifications Vocales</h1>
    <h2>Endpoints disponibles:</h2>
    <ul>
        <li><code>GET /notifications/</code> - Récupérer les notifications</li>
        <li><code>GET /audio_files/&lt;filename&gt;</code> - Télécharger un fichier audio</li>
        <li><code>POST /generate_notification</code> - Générer une notification manuellement</li>
        <li><code>POST /clear_notifications</code> - Effacer toutes les notifications</li>
        <li><code>GET /status</code> - Statut du serveur</li>
    </ul>
    <h2>Configuration Flutter:</h2>
    <p>URL de base: <code>http://localhost:5000</code></p>
    <p>Notifications actives: <strong>{}</strong></p>
    """.format(len(generated_notifications))

if __name__ == '__main__':
    print("🚀 Démarrage du serveur de notifications vocales...")
    print("📱 Configurez Flutter avec l'URL: http://localhost:5000")
    print("🔄 Les notifications sont générées aléatoirement toutes les ~50 secondes")
    
    # Générer une notification initiale pour le test
    generate_new_notification()
    
    app.run(host='0.0.0.0', port=5000, debug=True)