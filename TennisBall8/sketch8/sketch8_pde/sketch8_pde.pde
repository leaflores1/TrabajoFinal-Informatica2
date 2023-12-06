import processing.serial.*;
import java.io.*;
import java.util.ArrayList;

processing.serial.Serial arduinoPort;
boolean arduinoConnected = false;
int barraX;
int velocidadBarra = 20;
int barraAncho = 200;
int barraAlto = 15;
int bolaX;
int bolaY;
int bolaVelocidadX = 5;
int bolaVelocidadY = 5;
int bolaDiametro = 20;
boolean gameOver = false;
int muertes = 0;
PImage fondo;
char input;

ArrayList<Estadisticas> estadisticasList = new ArrayList<Estadisticas>();
int tiempoTotal;

void setup() {
  fondo = loadImage("C:/Users/leandro/OneDrive/Desktop/TennisBall8/sketch8/imagen1.jpg");
  String[] ports = processing.serial.Serial.list();
  if (ports.length > 0) { //hay puertos seriales disponibles?
     arduinoPort = new processing.serial.Serial(this, ports[0], 9600);
    arduinoConnected = true;
  } else {
    println("Arduino no conectado. Verificar puerto.");
  }

  size(800, 600);
  barraX = width / 2 - barraAncho / 2;
  bolaX = width / 2;
  bolaY = 50;

  tiempoTotal = millis();
  cargarEstadisticas();
}

void draw() {
  background(fondo);

  fill(0, 100, 10);
  rect(barraX, height - barraAlto, barraAncho, barraAlto);

  fill(255, 0, 0);
  ellipse(bolaX, bolaY, bolaDiametro, bolaDiametro);

  if (arduinoConnected && arduinoPort.available() > 0) {
    input = arduinoPort.readChar();
    interpretarSenal(input);
  }
  if(input == '5'){
    reiniciarJuego();
  }

  if (gameOver == false) {
    logica();
  } else {
    textSize(32);
    fill(255);
    text("Juego Terminado - Presiona 'R' para reiniciar", width / 2 - 300, height / 2);
  }
}

void interpretarSenal(char senal) {
  switch (senal) {
    case '1':
      // Lógica para mover la barra a la derecha
      barraX += velocidadBarra;
      break;
    case '2':
      // Lógica para mover la barra a la izquierda
      barraX -= velocidadBarra;
      break;
    case '5':
      // Lógica para reiniciar el juego
      reiniciarJuego();
      muertes = 0;
      gameOver = false;
      break;
  }
}

void logica() {
  textSize(30);
  fill(255);
  text("Muertes:", 10, 30);
  text(muertes, 130, 30);

  bolaX = bolaX + bolaVelocidadX;

  if ((bolaX > 780) || (bolaX < 20)) {
    bolaVelocidadX = bolaVelocidadX * -1;
  }

  bolaY = bolaY + bolaVelocidadY;

  if (bolaY > height || bolaY < 0) {
    bolaVelocidadY = bolaVelocidadY * -1;
  }

  if (bolaY >= height - 20 && (barraX <= bolaX) && (bolaX <= barraX + barraAncho)) {
    bolaVelocidadY = -(bolaVelocidadY + 2);
    bolaVelocidadX += 1;
  }

                   
                 
                if (bolaY >= height) {
                  reiniciarJuego();
                  muertes++;
                  guardarEstadisticas();
              
                  if (arduinoPort != null) {
                    arduinoPort.write('3');  
                  }
                }
    
                if (muertes > 2) {
                  gameOver = true;
                  if (arduinoPort != null) {
                    arduinoPort.write('4');
                  }
                }
                
}

void reiniciarJuego() {
  bolaX = width / 2;
  bolaY = 50;
  bolaVelocidadY = 5;
  bolaVelocidadX = 5;
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    reiniciarJuego();
    muertes = 0;
    gameOver = false;
  } else if (key == CODED) {
    if (keyCode == LEFT) {
      barraX = barraX - velocidadBarra;
    } else if (keyCode == RIGHT) {
      barraX = barraX + velocidadBarra;
    }
  }
}

class Estadisticas {
  int muertes;
  int tiempoJuego;

  Estadisticas(int muertes, int tiempoJuego) {
    this.muertes = muertes;
    this.tiempoJuego = tiempoJuego;
  }
}

void cargarEstadisticas() {
  try {
    BufferedReader br = new BufferedReader(new FileReader("C:/Users/leandro/OneDrive/Desktop/TennisBall8/sketch8/estadisticas.txt"));
    String line;
    while ((line = br.readLine()) != null) {
      String[] parts = line.split(": ");
      if (parts.length == 2) {
        int muertes = Integer.parseInt(parts[1].split(",")[0]);
        int tiempoJuego = Integer.parseInt(parts[1].split(": ")[1].replace(" milisegundos", ""));
        estadisticasList.add(new Estadisticas(muertes, tiempoJuego));
      }
    }
    br.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
}

void guardarEstadisticas() {
  int tiempoJuego = millis() - tiempoTotal;
  try {
    PrintWriter writer = new PrintWriter(new FileWriter("C:/Users/leandro/OneDrive/Desktop/TennisBall8/sketch8/estadisticas.txt", true));
    writer.println("Muertes: " + muertes + ", Tiempo total de juego: " + tiempoJuego + " milisegundos");
    writer.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
}
