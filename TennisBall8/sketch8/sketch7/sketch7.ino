const int botonDerechaPin = 2;
const int botonIzquierdaPin = 3;
const int resetPin = 5;
const int ledRojoPin = 8;
const int ledVerdePin = 9;

void setup() {
  Serial.begin(9600);
  pinMode(botonDerechaPin, INPUT_PULLUP);
  pinMode(botonIzquierdaPin, INPUT_PULLUP);
   pinMode(resetPin, INPUT_PULLUP);
  pinMode(ledRojoPin, OUTPUT);
  pinMode(ledVerdePin, OUTPUT);
}

void loop() {
  if (digitalRead(botonDerechaPin) == LOW) {
    Serial.write('1');  // Enviar señal para mover la barra a la derecha
  } else if (digitalRead(botonIzquierdaPin) == LOW) {
    Serial.write('2');  // Enviar señal para mover la barra a la izquierda
  }

if (digitalRead(resetPin) == LOW) {
    Serial.write('5');  
  }

  delay(50);  // Evitar rebotes

   digitalWrite(ledVerdePin, HIGH);

  // Leer desde Serial
  if (Serial.available() > 0) {
    char nrorecibido = Serial.read();

    // Lógica para interpretar la señal desde Processing
    switch (nrorecibido) {
      case '3':   //hubo una muerte      
        digitalWrite(ledRojoPin, HIGH);
        digitalWrite(ledVerdePin, LOW);
        delay(1000);
        digitalWrite(ledRojoPin, LOW);       
        digitalWrite(ledVerdePin, HIGH);
        break;
      case '4':
        // El juego ha terminado 
        digitalWrite(ledRojoPin, HIGH);
        digitalWrite(ledVerdePin, LOW);
        break;
      
      
    }
  }
}
