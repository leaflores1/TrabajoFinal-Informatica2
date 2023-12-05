import processing.serial.*;
import java.io.*;
import java.util.ArrayList;

processing.serial.Serial arduinoPort;

boolean Menu = true;
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
int cont = 0, muertes = 0;

ArrayList<Estadisticas> estadisticasList = new ArrayList<Estadisticas>();
int tiempoTotal;

void setup() {
  // Iniciar la comunicación con Arduino 
   String[] ports = processing.serial.Serial.list();
  if (ports.length > 0) {
    arduinoPort = new processing.serial.Serial(this, ports[0], 9600);
    arduinoConnected = true;
  } else {
    println("Arduino no conectado. Verificar puerto.");
  }

  size(800, 600);
  barraX = width / 2 - barraAncho / 2;
  bolaX = width / 2;
  bolaY = 50;

  // Inicializar el tiempo total
  tiempoTotal = millis();

  // Cargar estadísticas existentes desde el archivo
  cargarEstadisticas();
}

void draw() {
  background(50, 100, 400);

  fill(0, 100, 10);
  rect(barraX, height - barraAlto, barraAncho, barraAlto);

  fill(255, 0, 0);
  ellipse(bolaX, bolaY, bolaDiametro, bolaDiametro);

  if (arduinoConnected && arduinoPort.available() > 0) {
    char input = arduinoPort.readChar();
    interpretarSenal(input);
  }


  if (gameOver == false) {
    logica();
  } else {
    textSize(32);
    fill(255);
    text("Juego Terminado", width/2 - 150, height/2);
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
    // Otros casos según sea necesario
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
    // Guardar estadísticas después de cada muerte
    guardarEstadisticas();
  }

  if (muertes > 2) {
    gameOver = true;
  }
}

void reiniciarJuego() {
  bolaX = width / 2;
  bolaY = 50;
  bolaVelocidadY = 5;
  bolaVelocidadX = 5;
}

void keyPressed() {
  if (keyPressed) {
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
    BufferedReader br = new BufferedReader(new FileReader("C:/Users/leandro/OneDrive/Desktop/TennisBall5/sketch_231204c/estadisticas.txt"));
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
    PrintWriter writer = new PrintWriter(new FileWriter("C:/Users/leandro/OneDrive/Desktop/TennisBall5/sketch_231204c/estadisticas.txt", true));
    writer.println("Muertes: " + muertes + ", Tiempo total de juego: " + tiempoJuego + " milisegundos");
    writer.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
}
