#include <Servo.h>

Servo monServo;

const int pinServo = 9;
int angle = 0;
unsigned long dernierTemps = 0;
const unsigned long intervalle = 10000; // 10 secondes

void setup() {
  Serial.begin(115200);
  monServo.attach(pinServo);
  monServo.write(angle);  // Position initiale
  Serial.println("Début à 0°");
}

void loop() {
  unsigned long tempsActuel = millis();

  if (tempsActuel - dernierTemps >= intervalle) {
    dernierTemps = tempsActuel;

    angle += 20;
    // Choisir l'angle selon le type de plantation pour la rotation de la caméra
    if (angle > 80) {
      angle = 0;  // Revenir à 0° une fois atteint 180°
      Serial.println("Retour à 0°");
    } else {
      Serial.print("Servo à ");
      Serial.print(angle);
      Serial.println("°");
    }

    monServo.write(angle);  // Déplacement du servo
  }

}
