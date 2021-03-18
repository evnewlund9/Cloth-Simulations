class Thread{
  
  public Point a, b;
  public float restLength;

  public Vec3 force;
  
  public float k, kv;
  
  
  public Thread(Point a, Point b, float k, float kv){
    this.a = a;
    this.b = b;
    restLength = a.pos.distanceTo(b.pos); 
    this.k = k;
    this.kv = kv;
  }
  
  public void updateForce(float dt){
    Vec3 dir = b.pos.minus(a.pos);
    float l = sqrt(dot(dir,dir));
    Vec3 unitVec = dir.times(1/l);
    float strForce = -k * (restLength - l);
    
    
    float v1 = dot(unitVec, a.vel);
    float v2 = dot(unitVec, b.vel);
    float dampForce = -kv * (v1 - v2);   
    
    
    
    float f = strForce + dampForce;
    force = unitVec.times(f * dt);
  }
  
  public void update(){
    a.update(force);
    b.update(force.times(-1));
  }
  
  
  public void display(Vec3 col){
    Vec3 p1 = a.pos;
    Vec3 p2 = b.pos;
    stroke(col.x, col.y, col.z);
    strokeWeight(3);
    line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
    
  }
  
}
