class Edge {
  PVector a;
  PVector b;

  PVector normal;

  PVector neighbour;
  float neighbour_dist;

  Edge(PVector a_, PVector b_, boolean flip_normal) {
    a = a_;
    b = b_;
    normal = PVector.sub(a, b).normalize();
    if (flip_normal) {
      normal.set(-normal.y, normal.x);
    } else {
      normal.set(normal.y, -normal.x);
    }
  }


  float normal_dist(PVector p) {
    //float da = a.dist(p), db = b.dist(p), e = a.dist(b);
    //return sqrt(2*(da*da*db*db + e*e*da*da  + e*e*db*db) - (da*da*da*da + db*db*db*db + e*e*e*e))/(2*e);

    PVector ab = PVector.sub(b, a);
    //PVector tang = ab.normalize(null);
    //PVector normal = new PVector(-ab.y, ab.x).normalize();
    //if (neighbour != null && normal.dot(neighbour) < 0) {
    //  normal.mult(-1);
    //}
    PVector ap = PVector.sub(p, a);
    float x = ab.dot(ap);
    float d = normal.dot(ap);
    if ( d >= 0 ) {
      if ( x <= 0) {
        //println("a side");
        return a.dist(p);
      } else if (x > ab.magSq()) {
        //println("b side");
        return b.dist(p);
      } else {
        //println("center");
        return d;
      }
    } else {
      return Float.MAX_VALUE;
    }
  }

  void show(boolean special) {
    if (special) {
      stroke(#00ffff);
    } else {
      stroke(0);
    }
    line(this);
    show_normal();
  }

  void show_normal() {
    stroke(#ff0000);
    PVector center = PVector.add(a, b).mult(0.5);
    line(center.x, center.y, center.x+10*normal.x, center.y+10*normal.y);
  }

  String toString() {
    return "("+a.toString() + ", " + b.toString() + ")";
  }

  boolean equals(Edge other) {
    return a == other.a && b == other.b ||a == other.b && b == other.a;
  }
}
