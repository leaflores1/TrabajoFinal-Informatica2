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
int bolaVelocidadX = 5;
int bolaVelocidadY = 5;
int bolaDiametro = 20;
boolean gameOver = false;
int cont=0, muertes=0;

void setup() {
      
      
      // Iniciar la comunicación con Arduino 
      String[] ports = Serial.list();
      if (ports.length > 0) {
      arduinoPort = new Serial(this, ports[0], 9600);
      arduinoConnected = true;
      } else {
      println("Arduino no conectado. Verificar puerto.");
      }
      
      size(800, 600); //tamaño de la pagina en x(800) y en y(600)
      barraX = width / 2 - barraAncho / 2;//punto principal //la barre parte de la mitad de la pantalla
      bolaX = width / 2; //la bola parte de la mitad de la pantalla 600/2
      bolaY = 50; //la bola parte de la altura 50
}


void draw() {
              background(50, 100, 400);   
              // Dibuja la barra
              fill(0,100,10);
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
              
             //CUANDO SE INICIA EL JUEGO?
             if(gameOver==false){
               logica();
             }else{
               //DISEÑO DEL TEXTO
                  textSize(32); 
                  fill(255);
                  text("Juego Terminado", width/2 - 150, height/2);
             }
              
          }
                     
void logica(){
  
        textSize(30);
        fill(255);
        text("Muertes:", 10,30);
        text(muertes, 130,30);
  
 bolaX= bolaX+bolaVelocidadX;
 
  if((bolaX>780) || (bolaX<20)){
    bolaVelocidadX= bolaVelocidadX *-1; //cambia el sentido
  }
  
  bolaY= bolaY + bolaVelocidadY;
  
  if(bolaY>height || bolaY <0){
    bolaVelocidadY = bolaVelocidadY*-1;//cambia el sentido
  }
  
  //INTERACCION CON LA BARRA
  if(bolaY>=height-20 && (barraX <= bolaX) && (bolaX <= barraX+barraAncho)){
   // bolaVelocidadY= bolaVelocidadY*-1;
     bolaVelocidadY=-(bolaVelocidadY+2);
     bolaVelocidadX+=1;
  }
  
  //CUANDO SE PIERDE? --> gameover = true
  if(bolaY>=height){
      if(bolaY>=height){ //Se resetean los valores
        bolaX= width / 2;
        bolaY= 50;
        bolaVelocidadY= 5;
        bolaVelocidadX= 5;
        muertes++;
      }
  }
  if(muertes>2){
    gameOver=true;
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
}
