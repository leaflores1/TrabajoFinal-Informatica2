import processing.serial.*;
Serial arduinoPort;

boolean Menu = true;
boolean arduinoConnected = false;
int barraX;
int velocidadBarra = 20;
int barraAncho = 200; //width
int barraAlto = 15; //height
int bolaX;
int bolaY;
int bolaVelocidad = 5;
int bolaDiametro = 20;
boolean gameOver = false;
int cont=0;

void setup() {
      
      
      // Iniciar la comunicación con Arduino 
      String[] ports = Serial.list();
      if (ports.length > 0) {
      arduinoPort = new Serial(this, ports[0], 9600);
      arduinoConnected = true;
      } else {
      println("Arduino no conectado. Verificar puerto.");
      }
      
      size(800, 600); //tamaño de la pagina en y(800) y en x(600)
      barraX = width / 2 - barraAncho / 2;//punto principal //la barre parte de la mitad de la pantalla
      bolaX = width / 2; //la bola parte de la mitad de la pantalla 600/2
      bolaY = 50; //la bola parte de la altura 50
}


void draw() {
            background(0);   
            // Dibuja la barra
            fill(0, 0, 255);
            rect(barraX, height - barraAlto, barraAncho, barraAlto);
            
            // Dibuja la pelota
            fill(255, 0, 0);
            ellipse(bolaX, bolaY, bolaDiametro, bolaDiametro);
            
              // Controla la barra con los botones de Arduino o teclado
            if (arduinoConnected && arduinoPort.available() > 0) {
            String input = arduinoPort.readStringUntil('\n');
              if (input != null) {
              barraX = PApplet.parseInt(input);  
              }
            } 
           //INICIAR MENU
            if(Menu) {
              mostrarMenu();
                }else {
              logica();
            }
          }
          
void mostrarMenu() {
  textSize(32);
  fill(255);
  text("Desea empezar a jugar?", width/2 - 200, height/2);
  text("Presione 's' para comenzar", width/2 - 150, height/2 + 40);
}
                         
void logica(){   
  
            // MOVIMIENTO DE LA PELOTA EN Y HACIA ABAJO
            if (gameOver != true){ //si game over sigue siendo falso, osea el juego aun no termina
              if(cont==0){
                bolaY = bolaY + bolaVelocidad; //sentido de velocidad hacia abajo
               }   
              if(cont!=0){ //si las posiciones de bola y barra coinciden el cont es !=0, cambiar sentido de velocidad  
                  bolaY = bolaY - bolaVelocidad;
                  if(bolaY==10){ //si la bola llega a la altura 10 que invierta el sentido
                    cont=0;
                  }
               }
             }
            
            //MOVIMIENTO DE LA PELOTA EN X 
             if (cont!=0 && gameOver != true){
               //if(barraX <= bolaX){ bolaX = bolaX + 1; } //si pega en el costado der la bola rebota a la derecha
                if(barraX+barraAncho >= bolaX){ bolaX = bolaX - 1; }
             }               
            
            // Verifica si la pelota cae fuera de la pantalla
            if (bolaY > height - bolaDiametro / 2) { //si el tam de la bola en y es mayor aL tam del pagina
            //if (bolaY > height)
            gameOver = true;
                  textSize(32); //DISEÑO DEL TEXTO
                  fill(255);
                  text("Juego Terminado", width/2 - 150, height/2);
            }
            
            //INTERACCION CON LA BARRA
           if(bolaY == height - bolaDiametro / 2){ //si la bola esta a ala altura de la barra
                if(barraX <= bolaX && bolaX <= barraX+barraAncho){          
                    //si la la pos de la bola en x coincide con la pos de la barra en x (3 puntos)
                  cont++;        
                   }             
             }
          } 
   
void keyPressed() {
  // Controla la barra con las teclas de flecha izquierda y derecha
  if (keyPressed) {
    if (keyCode == LEFT) {
      barraX = barraX - velocidadBarra;
    } else if (keyCode == RIGHT) {
      barraX = barraX + velocidadBarra;
    }
  }

  // Iniciar el juego si se presiona 's' en el menú
  if (Menu && (key == 's' || key == 'S')) {
    Menu = false;
  }
}
