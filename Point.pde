class Point {
  
  public Vec3 pos; 
  public Vec3 vel;
  public Vec3 acc;
  public boolean locked;
  public int i, j;
  
  
  public Point(Vec3 pos, Vec3 vel, Vec3 acc, boolean locked, int i, int j){
    this.pos = pos;
    this.vel = vel;
    this.acc = acc;
    this.locked = locked;
    this.i = i;
    this.j = j;
  }
    
 public void update(Vec3 force){
    Vec3 aeroForce = new Vec3(0,0,0);
    
    if (i < (rows - 1) && j < (cols - 1)){
      Vec3 pos1 = points[i+1][j].pos;
      Vec3 pos2 = points[i][j+1].pos;
      float a0 = 0.5 * ((cross(pos2.minus(pos), pos1.minus(pos))).length());
      
      Vec3 v = (vel.plus(points[i+1][j].vel).plus(points[i][j+1].vel)).times(1/3);
      v.subtract(airVel);
      
      Vec3 n1 = cross(pos2.minus(pos), pos1.minus(pos));
      float n2 = cross(pos2.minus(pos), pos1.minus(pos)).length();
      Vec3 n = n1.times(1/n2);
      
      float a = a0 * ((dot(v,n)) / (v.length()));
      
      float aeroScalar = -0.5 * airDensity * (v.length() * v.length()) * a;
      aeroForce = n.times(aeroScalar / 3);
    }
    
    Vec3 f = force.plus(aeroForce);
    
    vel.add(f.plus(gravity).times(dt));
    if (!locked) pos.add(vel.times(dt));
    
    float d = SpherePos.distanceTo(pos);
    if(d < sphereRadius + 0.9){
      Vec3 n = SpherePos.minus(pos).times(-1);
      n.normalize();
      vel.subtract(n.times(dot(vel, n)).times(1.5));
      pos.add(n.times(0.1+sphereRadius-d).times(-1));
    }
  }
  
}
