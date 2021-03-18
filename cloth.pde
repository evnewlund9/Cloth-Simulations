Camera camera;
PImage bg; 

int rows = 20;
int cols = 20;

float k = 2000;
float kv = 5000;
float l0 = 10;
public float airDensity = 0.5;
public Vec3 gravity = new Vec3(0,0.015, 0);
public Vec3 airVel = new Vec3(0,-0.01,0);

public Point points[][];
Thread xThreads[][];
Thread yThreads[][];
Thread leftDiagThreads[][];
Thread rightDiagThreads[][];

public float dt = 0.015;
boolean lock = false;
boolean flag = false;

public Vec3 SpherePos = new Vec3(100,200,100);
public float sphereRadius = 50;

Vec3 cameraPos = new Vec3( 300, 23, 465);
float theta = -12;
float phi = -0.285;

Vec3 xColor = new Vec3(0,255,255);
Vec3 yColor = new Vec3(128, 128, 128);
Vec3 diagColor = new Vec3(255,255,255);


void setup(){
  size(849,849,P3D);
  bg = loadImage("bg.jpg");
  camera = new Camera(cameraPos, theta, phi);
  points = new Point[rows][cols];
  xThreads = new Thread[rows][(cols-1)];
  yThreads = new Thread[(rows-1)][cols];
  leftDiagThreads = new Thread[rows-2][cols-2];
  rightDiagThreads = new Thread[rows-2][cols-2];
  
  for(int i = 0; i < rows; i++){
    for(int j = 0; j < cols; j++){
      if (flag){
         if(i ==0 && j == 0 || i ==0 && j == cols-1) points[i][j] = new Point(new Vec3(i*10, j*10, 50), new Vec3(0,0,0), new Vec3(0,0,0), true, i, j);
         else points[i][j] = new Point(new Vec3(i*10, j*10, 50), new Vec3(0,0,0), new Vec3(0,0,0), false,i, j);
      }
      else{
        if(i ==0 && lock) points[i][j] = new Point(new Vec3(i*10, 75, j * 10), new Vec3(0,0,0), new Vec3(0,0,0), true, i, j);
        else points[i][j] = new Point(new Vec3(i*10,75, j*10), new Vec3(0,0,0), new Vec3(0,0,0), false,i, j);
      }
    }
  }
 
  for(int i=0; i < rows; i++){
    for(int j=0; j < cols; j++){
      Point p0 = points[i][j];
      if(j < (cols - 1)) xThreads[i][j] = new Thread(p0, points[i][j+1], k, kv);
      if(i < (rows - 1)) yThreads[i][j] = new Thread(p0, points[i+1][j], k, kv);
      if(j < (cols - 2) && i < (rows - 2)){
        rightDiagThreads[i][j] = new Thread(p0, points[i+2][j+2], (k/2), (kv/2));
      }
      if(j > 1 && i < (rows - 2)){
        leftDiagThreads[i][j-2] = new Thread(p0, points[i+2][j-2], (k/2), (kv/2));
      }
      
    }
  }
}

void draw(){
  if (flag) background(bg);
  else background(0);
  camera.Update(1.0/frameRate);
  fill(255, 0, 0);
  lights();
  if (!flag){
    pushMatrix();
    stroke(255,0,0);
    translate(SpherePos.x, SpherePos.y, SpherePos.z);
    sphere(sphereRadius);
    popMatrix();
  }
  else{
    fill(220, 200, 200);
    quad(5, 0, 0, 0, 5, 300, 0, 300);
  }
  strokeWeight(2);
  
  for(int i = 0; i < 20; i++){
      update(1/(20*frameRate));
  }
   for(int i = 0; i < rows; i++){
    for(int j = 0; j < cols; j++){
      if(j < (cols - 1)) {xThreads[i][j].display(xColor);} 
      if(i < (rows - 1)) {yThreads[i][j].display(yColor); }
      if(i < (rows - 2) && j < (cols - 2)){
        leftDiagThreads[i][j].display(diagColor);
        rightDiagThreads[i][j].display(diagColor);
      }
    }
  }
}

void update(float dt){
  for(int i = 0; i < rows; i++){
    for(int j = 0; j < cols; j++){
      if(j < (cols - 1)) xThreads[i][j].updateForce(dt);
      if(i < (rows - 1)) yThreads[i][j].updateForce(dt);
      if(i < (rows - 2) && j < (cols - 2)){
        leftDiagThreads[i][j].updateForce(dt);
        rightDiagThreads[i][j].updateForce(dt);
      }
    }
  }
  for(int i = 0; i < rows; i++){
    for(int j = 0; j < cols; j++){
      if(j < (cols - 1)) {
        xThreads[i][j].update();
      }
      if(i < (rows - 1)) {
        yThreads[i][j].update();
      }
      if(i < (rows - 2) && j < (cols - 2)){
        leftDiagThreads[i][j].update();
        rightDiagThreads[i][j].update();
      }
      
    }
  }
}

void keyPressed(){
  if(key == 'f'){
    cameraPos = new Vec3(-3.2121553, 3.3335178, 470.65375);
    theta = -12.697506;
    phi = -0.20815876;
    k = 10000;
    kv = 700;
    airDensity = 0.25;
    airVel = new Vec3(0.1,0,0);
    gravity = new Vec3(0,0.001, 0);
    xColor = new Vec3(255, 0, 0);
    yColor = new Vec3(0, 0, 255);
    diagColor = new Vec3(255,255,255);
    
    flag = true;
    lock = false;
    setup();
    draw();
  }
  else if(key == 'l'){
    cameraPos = new Vec3( 300, 23, 465);
    theta = -12;
    phi = -0.285;
    k = 1500;
    kv = 3000;
    airDensity = 0.35;
    airVel = new Vec3(0,-0.01,0);
    gravity = new Vec3(0,0.01, 0);
    xColor = new Vec3(255, 0, 127);
    yColor = new Vec3(128, 128, 128);
    diagColor = new Vec3(255,255,255);
    
    lock = true;
    flag = false;
    setup();
    draw();    
  }
  else if(key == 'u'){
    cameraPos = new Vec3( 300, 23, 465);
    theta = -12;
    phi = -0.285;
    k = 2000;
    kv = 5000;
    airDensity = 0.5;
    airVel = new Vec3(0,-0.01,0);
    gravity = new Vec3(0,0.015, 0);
    xColor = new Vec3(0,255,255);
    yColor = new Vec3(128, 128, 128);
    diagColor = new Vec3(255,255,255);
    
    lock = false;
    flag = false;
    setup();
    draw();    
  }
  else camera.HandleKeyPressed();
}


void keyReleased()
{
  camera.HandleKeyReleased();
}
