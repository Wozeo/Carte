
//Parametres

int r = 1;//Résolution
int tx = 1920/r, ty = 1080/r;//Dimension de l'écran
float niveauOcean = -5, hautMont = 20;
float noiseScale = 0.01;


//Autre
int nbLayer = 2;
float [][][] carte = new float [tx][ty][nbLayer];



void setup() {
  
  fullScreen();
  def();
  
}


void def() {
  println("affichage");
  for (int i = 0; i < tx; i ++) {
    for (int j = 0; j < ty; j ++) {
      carte[i][j][0] = 0;
      carte[i][j][1] = 0;
    }
  }

  int nS1 = int(random(-2147483648, 2147483647));
  noiseSeed(nS1);
  for (int i = 0; i < tx; i ++) {
    for (int j = 0; j < ty; j ++) {
      float noise = noise(i*noiseScale, j*noiseScale)-0.5;
      carte[i][j][0] = noise*100;
    }
  }
  
  int nS2 = int(random(-2147483648, 2147483647));
  noiseSeed(nS2);
  for (int i = 0; i < tx; i ++) {
    for (int j = 0; j < ty; j ++) {
      if (carte[i][j][0] >= niveauOcean && carte[i][j][0] < hautMont) {
        float noise = noise(i*noiseScale, j*noiseScale)-0.5;
        if (noise*100 > 10 ) {
          if (carte[i][j][0] >= niveauOcean+abs(niveauOcean)*0.4) {
            carte[i][j][1] = 1;
          }
        } else if (noise*100 < -25) {
          carte[i][j][1] = 2;
        } else {
          carte[i][j][1] = 0;
        }
      }
    }
  }

  dessin();
}


void draw() {
}


void dessin() {
  
  background(255);
  for (int i = 0; i < tx; i ++) {
    for (int j = 0; j < ty; j ++) {
      noStroke();
      if (carte[i][j][1] == 1) {//Plaine
        fill(30, 125, 15 );
        rect(i*r, j*r, r, r);
      } else if (carte[i][j][1] == 2) {//Desert
        fill(245, 245, 20 );
        rect(i*r, j*r, r, r);
      } else {
        if (carte[i][j][0] < niveauOcean) {//eau
          fill(50, 50, 155+map(carte[i][j][0], -50, 0, 0, 100) );
          rect(i*r, j*r, r, r);
        } else if (carte[i][j][0] < hautMont) {//foret
          fill(60, 175, 60 );
          rect(i*r, j*r, r, r);
        } else {//montagne
          float col = map(carte[i][j][0], 20, 50, 120, 255);
          fill(col, col, col );
          rect(i*r, j*r, r, r);
        }
      }
    }
  }
  
}


void mouseClicked() {
  if (mouseButton == LEFT) {
    def();
  } else {
    int r = int(random(0, 987654321));
    saveFrame("Carte-"+r+".png");
    println("Sauvegarde : "+r);
    background(0);
    dessin();
  }
}
