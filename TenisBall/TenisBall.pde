import processing.serial.*;
Serial arduinoPort;

boolean arduinoConnected = false;
int barraX;
int velocidadBarra = 20;
int barraAncho = 400; //width
int barraAlto = 10; //height
int bolaX;
int bolaY;
int bolaVelocidad = 5;
int bolaDiametro = 20;
boolean gameOver = false;

void setup() {
      size(800, 600);
      // Iniciar la comunicación con Arduino 
      String[] ports = Serial.list();
      if (ports.length > 0) {
      arduinoPort = new Serial(this, ports[0], 9600);
      arduinoConnected = true;
      } else {
      println("Arduino no conectado. Verificar puerto.");
      }
      barraX = width / 2 - barraAncho / 2; 
      bolaX = width / 2;
      bolaY = 50;
}
void draw() {
      background(0);   
      // Dibuja la barra
      fill(0, 0, 255);
      rect(barraX, height - barraAlto, barraAncho, barraAlto);
      
      // Dibuja la pelota
      fill(255, 0, 0);
      ellipse(bolaX, bolaY, bolaDiametro, bolaDiametro);
      
      // Mueve la pelota hacia abajo
      if (!gameOver) {
      bolaY += bolaVelocidad;
      }
      
      // Controla la barra con los botones de Arduino o teclado
      if (arduinoConnected && arduinoPort.available() > 0) {
      String input = arduinoPort.readStringUntil('\n');
        if (input != null) {
        barraX = PApplet.parseInt(input);
        }
      }
      
      // Verifica si la pelota cae fuera de la pantalla
      if (bolaY > height - bolaDiametro / 2) {
      gameOver = true;
      textSize(32);
      fill(255);
      text("Juego Terminado", width/2 - 150, height/2);
      }
}
void keyPressed() { // Controla la barra con las teclas de flecha izquierda y derecha      
      if (keyCode == LEFT) {
      barraX -= velocidadBarra;
      } else if (keyCode == RIGHT) {
          barraX += velocidadBarra;
      }
}
