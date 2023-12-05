const int botonDerechaPin = 2;
const int botonIzquierdaPin = 3;
const int ledRojoPin = 8;
const int ledVerdePin = 9;

void setup() {
  Serial.begin(9600);
  pinMode(botonDerechaPin, INPUT_PULLUP);
  pinMode(botonIzquierdaPin, INPUT_PULLUP);
  pinMode(ledRojoPin, OUTPUT);
  pinMode(ledVerdePin, OUTPUT);
}

void loop() {
  if (digitalRead(botonDerechaPin) == LOW) {
    Serial.write('1');  // Enviar señal para mover la barra a la derecha
  } else if (digitalRead(botonIzquierdaPin) == LOW) {
    Serial.write('2');  // Enviar señal para mover la barra a la izquierda
  }

  delay(50);  // Evitar rebotes

  // Leer desde Serial
  if (Serial.available() > 0) {
    char nrorecibido = Serial.read();

    // Lógica para interpretar la señal desde Processing
    switch (nrorecibido) {
      case '3':
        // La pelota está en juego, apagar LED rojo y encender LED verde
        digitalWrite(ledRojoPin, HIGH);
        digitalWrite(ledVerdePin, LOW);
        break;
      case '4':
        // El juego ha terminado, apagar LED verde y encender LED rojo
        digitalWrite(ledRojoPin, LOW);
        digitalWrite(ledVerdePin, HIGH);
        break;
      // Puedes agregar más casos según sea necesario
    }
  }
}
