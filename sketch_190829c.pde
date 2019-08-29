class V3D {
  float x, y, z;
  V3D(float vx, float vy, float vz) {
    this.x=vx;
    this.y=vy;
    this.z=vz;
  }
  V3D() {
    this.x=0;
    this.y=0;
    this.z=0;
  }
}
class Sphere {
  V3D position, forward, up, right, velocity, acceleration;
  float radius, mass;
  Sphere() {
    this.position=new V3D();
    this.forward=new V3D();
    this.up=new V3D();
    this.right=new V3D();
    this.velocity=new V3D();
    this.acceleration=new V3D();
    this.radius=1.0f;
    this.mass=1.0f;
  }
  void motion(float time) {
    this.position.x+= this.velocity.x * time;
    this.position.y+= this.velocity.y * time;
    this.position.z+= this.velocity.z * time;
  }
  void acceleration(float time) {
    this.velocity.x+=this.acceleration.x * time;
    this.velocity.y+=this.acceleration.y * time;
    this.velocity.z+=this.acceleration.z * time;
  }
  void hansya() {
    if (this.position.x>width) {
      this.velocity.x*=-1;
      this.position.x=2*width-this.position.x;
    } else if (this.position.x<0) {
      this.velocity.x*=-1;
      this.position.x*=-1;
    }
    if (this.position.y>height) {
      this.velocity.y*=-1;
      this.position.y=2*height-this.position.y;
    } else if (this.position.y<0) {
      this.velocity.y*=-1;
      this.position.y*=-1;
    }
  }
}
boolean ballcollision(int ball1, int ball2, float time) {
  V3D v, b, dist;
  float r, l, len2, v2, work, r2;
  v=new V3D();
  b=new V3D();
  dist=new V3D();
  Sphere s1=maru[ball1];
  Sphere s2=maru[ball2];
  r = s1.radius + s2.radius ;
  v.x = (s1.velocity.x - s2.velocity.x)*time ;
  v.y = (s1.velocity.y - s2.velocity.y)*time ;
  v.z = (s1.velocity.z - s2.velocity.z)*time ;
  b.x = s1.position.x - s2.position.x ;
  b.y = s1.position.y - s2.position.y ;
  b.z = s1.position.z - s2.position.z ;
  l= b.x * v.x + b.y * v.y + b.z * v.z ;
  if (l >= 0.0d ) {
    len2 = b.x * b.x + b.y * b.y + b.z * b.z;
    r2 = r*r;
    if (len2<=r2) {
      return true;
    }
    return false;
  }
  v2 = v.x * v.x + v.y * v.y + v.z * v.z ;
  if ( v2 == 0.0d) {
    return false;
  }
  if ( l <= -v2) {
    dist.x = b.x + v.x ;
    dist.y = b.y + v.y ;
    dist.z = b.z + v.z ;
  } else {
    work = l / v2 ;
    dist.x = b.x - work * v.x ;
    dist.y = b.y - work * v.y ;
    dist.z = b.z - work * v.z ;
  }
  len2 = dist.x * dist.x + dist.y * dist.y + dist.z * dist.z ;
  r2 = r * r;
  if ( len2 <= r2) {
    return true;
  }
  return false;
}
float deltatime=24/60f;
int vol=50;
Sphere[] maru=new Sphere[vol];
void setup() {
  frameRate(60);
  size(400, 400,OPENGL);
  for (int i=0; i<vol; i++) {
    maru[i]=new Sphere();
    maru[i].radius=(float)(5+Math.random()*3+2);
    maru[i].velocity.x=(float)(Math.random()*12.5);
    maru[i].velocity.y=(float)(Math.random()*12.5);
    maru[i].mass=maru[i].radius*maru[i].radius;
    maru[i].position.x=(float)(Math.random()*width);
    maru[i].position.y=(float)(Math.random()*height);
  }
}
void draw() {
  background(255);
  fill(0);
  for (int i=0; i<vol; i++) {
    for (int j=i+1; j<vol; j++) {
      if (ballcollision(i, j, deltatime)) {
        float v1x=((maru[i].mass - maru[j].mass)*maru[i].velocity.x + 2* maru[j].mass * maru[j].velocity.x)/(maru[i].mass+maru[j].mass);
        float v1y=((maru[i].mass - maru[j].mass)*maru[i].velocity.y + 2* maru[j].mass * maru[j].velocity.y)/(maru[i].mass+maru[j].mass);
        float v2x=((maru[j].mass - maru[i].mass)*maru[j].velocity.x + 2* maru[i].mass * maru[i].velocity.x)/(maru[i].mass+maru[j].mass);
        float v2y=((maru[j].mass - maru[i].mass)*maru[j].velocity.y + 2* maru[i].mass * maru[i].velocity.y)/(maru[i].mass+maru[j].mass);
        maru[i].velocity.x =v1x;
        maru[i].velocity.y =v1y;
        maru[j].velocity.x =v2x;
        maru[j].velocity.y =v2y;
      }
    }
  }
  for (int i=0; i<vol; i++) {
    maru[i].acceleration(deltatime);
    maru[i].motion(deltatime);
    maru[i].hansya();
  }
  for (int i=0; i<vol; i++) {
    ellipse(maru[i].position.x, maru[i].position.y, maru[i].radius*2, maru[i].radius*2);
  }
}
