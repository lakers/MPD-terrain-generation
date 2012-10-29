//Generates terrain using mid-point displacement. Use a and s to rotate the image.

float[][] hm;
int dim;
float d;
float r = 0.5f;
float angle;

void setup() {
  size(800, 600, P3D);
  dim = 257;
  hm = new float[dim][dim];
  initializeCorners(hm, dim);
  d = 20.0f;
  MPD(hm, dim, 0);
  MPD(hm, dim, 1);
  MPD(hm, dim, 2);
  MPD(hm, dim, 3);
  MPD(hm, dim, 4);
  MPD(hm, dim, 5);
  MPD(hm, dim, 6);
  MPD(hm, dim, 7);
  angle = 0;
}

void draw() {
  background(0);
  lights();
  //stroke(255);
  noStroke();
  //smooth();
  //noFill();
  translate(300, 300, 0);
  scale(5);
  //rotateY(map(mouseX, 0, width, 0, PI));
  //rotateZ(map(mouseY, 0, height, 0, -PI));
  //rotateY(radians(60));
  rotateX(radians(60));
  translate(50, 50, 0);
  rotateZ(angle);
  translate(-50, -50, 0);
  for(int x = 0; x < dim-1; x++) {
    for(int y = 0; y < dim-1; y++) {
      beginShape(TRIANGLE_STRIP);
      vertex(x, y, hm[x][y]);
      vertex(x+1, y, hm[x+1][y]);
      vertex(x, y+1, hm[x][y+1]);
      vertex(x+1, y+1, hm[x+1][y+1]);
      endShape();
    } 
  }
}

void keyPressed() {
  if(key == 'a') {
    angle += radians(10);
  } else if(key == 's') {
    angle -= radians(10); 
  }
}

void printmap(float[][] heightmap, int dim) {
  for(int x = 0; x < dim; x++) {
    for(int y = 0; y < dim; y++) {
      System.out.print(heightmap[x][y] + "  ");
    }
    System.out.println("");
  } 
  System.out.println("===========");
}

void MPD(float[][] heightmap, int dim, int pass) {
  int increment = (int)((dim-1)/(pow(2, pass)));
  for(int x = 0; x < dim-1; x += increment) {
    for(int y = 0; y < dim-1; y += increment) {
      float ul = heightmap[x][y];
      float ur = heightmap[x+increment][y];
      float ll = heightmap[x][y+increment];
      float lr = heightmap[x+increment][y+increment];
      float value = (ul + ur + ll + lr)/4;
      float randdiff = random(2 * d) - d;
      heightmap[x+(increment/2)][y+(increment/2)] = value + randdiff;
    }
  }
  d *= pow(2, -r);
  System.out.println(d);
  for(int x = 0; x <= dim-1; x += increment/2) {
    for(int y = 0; y <= dim-1; y += increment/2) {
      float num = 4;
      float val = 0;
      int xmod = x%(increment);
      int ymod = y%(increment);
      float randdiff = random(2 * d) - d;
      if(xmod == 0 && ymod != 0) {
        val += heightmap[x][y-increment/2];
        val += heightmap[x][y+increment/2];
        if(x == 0) {
          val += heightmap[x+increment/2][y];
          num = 3;
        } else if(x == dim-1) {
          val += heightmap[x-increment/2][y]; 
          num = 3;
        } else {
          val += heightmap[x+increment/2][y];
          val += heightmap[x-increment/2][y];  
          num = 4;
        }
        heightmap[x][y] = val/num + randdiff;
      } else if(xmod != 0 && ymod == 0) {
        val += heightmap[x-increment/2][y];
        val += heightmap[x+increment/2][y];
        if(y == 0) {
          val += heightmap[x][y+increment/2];
          num = 3;
        } else if(y == dim-1) {
          val += heightmap[x][y-increment/2];
          num = 3; 
        } else {
          val += heightmap[x][y+increment/2];
          val += heightmap[x][y-increment/2];
          num = 4;
        }
        heightmap[x][y] = val/num + randdiff;
      }
    } 
  }
  d *= pow(2, -r);
  System.out.println(d);
}

void initializeCorners(float[][] heightmap, int dim) {
  heightmap[0][0] = 20.0f;
  heightmap[0][dim-1] = 5.0f;
  heightmap[dim-1][0] = 6.0f;
  heightmap[dim-1][dim-1] = 28.0f;
}

