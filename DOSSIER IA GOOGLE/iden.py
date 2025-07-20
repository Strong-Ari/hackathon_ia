import streamlit as st
import tensorflow as tf
import cv2
import time
import numpy as np
import requests
import os
import warnings
import socket # Importation du module socket pour récupérer l'adresse IP

# Masquer spécifiquement l'avertissement de dépréciation de 'use_column_width'
warnings.filterwarnings(
    "ignore",
    category=DeprecationWarning,
    module="streamlit.elements.image",
    message="The use_column_width parameter has been deprecated and will be removed in a future release. Please utilize the use_container_width parameter instead."
)

# --- NOUVEAU : Récupération dynamique de l'adresse IP locale ---
def get_local_ip():
    """
    Tente de récupérer l'adresse IP locale de la machine.
    """
    try:
        # Crée une socket UDP temporaire pour se connecter à une adresse externe
        # Cela ne crée pas de connexion réelle, mais permet de déterminer l'IP locale
        # utilisée pour les communications sortantes.
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80)) # Google DNS est un bon choix pour une adresse externe fiable
        ip_address = s.getsockname()[0]
        s.close()
        return ip_address
    except Exception as e:
        st.warning(f"Impossible de récupérer l'adresse IP locale dynamiquement : {e}. Utilisation de 127.0.0.1 par défaut.")
        return "127.0.0.1" # Fallback vers localhost si l'IP ne peut pas être déterminée

LOCAL_IP = get_local_ip()
API_PORT = 8000 # Le port de votre API Flask
BASE_API_URL = f"http://{LOCAL_IP}:{API_PORT}"
# --- FIN NOUVEAU ---

# Charger le modèle
model = tf.keras.models.load_model(r"C:\Users\zokou\Downloads\tomato_disease_classifier.keras")
class_names = ['mildiou', 'tomate_saine']

def predict(image_array):
    img = cv2.resize(image_array, (224, 224))
    img = img.astype(np.float32) / 255.0
    img = np.expand_dims(img, axis=0)
    predictions = model.predict(img)
    confidence = np.max(predictions) * 100
    predicted_class = class_names[np.argmax(predictions)]
    return predicted_class, confidence, predictions[0]

st.title("Détection automatique via Webcam")

run = st.checkbox('Activer la webcam')

capture_folder = r"C:\Users\zokou\Downloads\captures"
if not os.path.exists(capture_folder):
    os.makedirs(capture_folder)
    st.info(f"Dossier '{capture_folder}' créé pour stocker les images de mildiou.")


if run:
    cap = cv2.VideoCapture(0)
    last_time = time.time()
    placeholder = st.empty()

    while True:
        ret, frame = cap.read()
        if not ret:
            st.write("Impossible de lire la caméra. Veuillez vérifier si la webcam est connectée et disponible.")
            break

        frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        placeholder.image(frame_rgb, channels="RGB", caption="Flux de la webcam", use_container_width=True)

        if time.time() - last_time >= 10:
            last_time = time.time()
            prediction, confidence, raw_scores = predict(frame_rgb)

            st.write(f"**Prédiction :** `{prediction}` avec une confiance de **{confidence:.2f}%**")
            st.write("Scores détaillés :")
            st.json({class_names[i]: f"{raw_scores[i]*100:.2f}%" for i in range(len(class_names))})

            if prediction == 'tomate_saine':
                st.write("Votre plantation est saine pour l'instant. Analyse continue...")
                continue

            elif prediction == 'mildiou':
                message = "Certains signes suspects ont été détectés dans votre plantation dans la zone de capture A, faisant penser que votre plantation se fait attaquer par la maladie de mildiou. Appliquez des fongicides à base de cuivre ainsi que des engrais biologiques pour atténuer l'impact de l'attaque. Contactez les services compétents pour de meilleures orientations."

                st.error(message)

                timestamp = time.strftime("%Y%m%d-%H%M%S")
                image_filename_local = f"mildiou_{timestamp}.jpg"
                image_filepath = os.path.join(capture_folder, image_filename_local)

                cv2.imwrite(image_filepath, frame)
                st.success(f"Image de mildiou sauvegardée localement dans : `{image_filepath}`")

                # --- CHANGEMENT : Utilisation de BASE_API_URL pour construire les URLs ---
                relative_image_path = f"captures/{image_filename_local}"
                full_image_url_for_display = f"{BASE_API_URL}/{relative_image_path}" # Cette URL est complète

                st.markdown(f"L'image est accessible en réseau via : [**{full_image_url_for_display}**]({full_image_url_for_display})")
                st.image(image_filepath, caption="Image de mildiou détecté", use_container_width=True)


                # --- Envoi de la notification avec l'URL COMPLÈTE de l'image ---
                try:
                    notif = {
                        "titre": "Alerte Mildiou - Analyse automatique",
                        "message": message,
                        "image_path": full_image_url_for_display # <-- CHANGEMENT ICI : Envoie l'URL complète
                    }
                    # La requête POST est envoyée à l'IP dynamique
                    response = requests.post(f"{BASE_API_URL}/notifications/", json=notif)
                    if response.status_code in [200, 201]:
                        st.write("Notification envoyée avec succès.")
                    else:
                        st.error(f"Erreur lors de l'envoi de la notification : {response.status_code} - {response.text}")
                except requests.exceptions.ConnectionError:
                    st.error(f"Impossible de se connecter au serveur de notifications. Assurez-vous qu'il est en cours d'exécution sur {BASE_API_URL}.")
                except Exception as e:
                    st.error(f"Erreur inattendue lors de l'envoi de la notification : {e}")

                break

    cap.release()
    st.write("Analyse de la webcam arrêtée.")

