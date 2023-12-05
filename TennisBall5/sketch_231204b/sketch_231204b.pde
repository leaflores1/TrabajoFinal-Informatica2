import processing.serial.*;
import java.io.*;

processing.serial.Serial arduinoPortSerial;

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

void setup() {
  // Iniciar la comunicación con Arduino
  String[] ports = processing.serial.Serial.list();

  if (ports.length > 0) {
    arduinoPortSerial = new processing.serial.Serial(this, ports[0], 9600);
    arduinoConnected = true;
  } else {
    println("Arduino no conectado. Verificar puerto.");
  }

  size(800, 600);
  barraX = width / 2 - barraAncho / 2;
  bolaX = width / 2;
  bolaY = 50;

  // Cargar estadísticas existentes desde el archivo
  cargarEstadisticas();
}

void draw() {
  background(50, 100, 400);

  fill(0, 100, 10);
  rect(barraX, height - barraAlto, barraAncho, barraAlto);

  fill(255, 0, 0);
  ellipse(bolaX, bolaY, bolaDiametro, bolaDiametro);

  if (arduinoConnected && arduinoPortSerial.available() > 0) {
    String input = arduinoPortSerial.readStringUntil('\n');
    if (input != null) {
      barraX = PApplet.parseInt(input);
    }
  }

  if (gameOver == false) {
    logica();
  } else {
    textSize(32);
    fill(255);
    text("Juego Terminado", width/2 - 150, height/2);
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

  Estadisticas(int muertes) {
    this.muertes = muertes;
  }
}

void cargarEstadisticas() {
  try {
    BufferedReader br = new BufferedReader(new FileReader("estadisticas.txt"));
    String line;
    while ((line = br.readLine()) != null) {
      int muertes = Integer.parseInt(line);
      estadisticasList.add(new Estadisticas(muertes));
    }
    br.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
}

void guardarEstadisticas() {
  try {
    PrintWriter writer = new PrintWriter(new FileWriter("estadisticas.txt", true));
    writer.println(muertes);
    writer.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
}
