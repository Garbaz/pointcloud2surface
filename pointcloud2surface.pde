ArrayList<PVector> points = new ArrayList<PVector>();

ArrayList<PVector> remains;
ArrayList<Edge> edges;
ArrayList<Edge> outer_edges;

void setup() {
  size(1000, 1000);
  for (int i = 0; i < 2; i++) {
    points.add(new PVector(random(100, 900), random(100, 900)));
  }

  //generate_surface();
  init();
  print(edges);
}

void draw() {
  background(0xCC);
  noStroke();
  fill(0);
  for (PVector p : points) {
    circle(p.x, p.y, 4);
  }
  fill(#00ff00);
  for (PVector p : remains) {
    circle(p.x, p.y, 6);
  }

  for (Edge e : edges) {
    e.show(false);
  }
  for (Edge e : outer_edges) {
    e.show(true);
  }


  //while (!remains.isEmpty()) {
  //step();
  //}
}


void keyPressed() {
  if (key == ' ') {
    //points.clear();
    //for (int i = 0; i < 100; i++) {
    //  points.add(new PVector(random(100, 900), random(100, 900)));
    //}
    //generate_surface();
    step();
  }
}
void mousePressed() {
  PVector m = new PVector(mouseX, mouseY);
  points.add(m);
  remains.add(m);
}

void generate_surface() {
  init();
  while (!remains.isEmpty()) {
    step();
  }
}

void init() {
  remains = (ArrayList<PVector>)points.clone();
  edges = new ArrayList<Edge>();
  outer_edges = new ArrayList<Edge>();

  PVector p1 = remains.get(0);
  //remains.remove(p1);
  PVector p2 = closest_point(remains, p1);
  //remains.remove(p2);
  add_edge(new Edge(p1, p2, false));
}

void step() {
  Edge with_next = closest_point(remains, outer_edges);
  //Edge with_next_s = closest_point(remains, outer_edges);
  //Edge with_next;
  //if (with_next_r.neighbour_dist < with_next_s.neighbour_dist) {
  //  with_next = with_next_r;
  //} else {
  //  with_next = with_next_s;
  //}
  if (with_next != null) {
    Edge na = new Edge(with_next.a, with_next.neighbour, false);
    Edge nb = new Edge(with_next.neighbour, with_next.b, false);
    //println(na + "   " + nb);

    //remains.remove(with_next.neighbour);

    if (outer_edges.size() > 1) {
      outer_edges.remove(with_next);
    } else {
      outer_edges.get(0).normal.mult(-1);
    }
    for (Edge e : edges) {
      if (e.equals(na)) {
        remains.remove(with_next.a);
        outer_edges.remove(e);
        na = null;
        break;
      } else if (e.equals(nb)) {
        remains.remove(with_next.b);
        outer_edges.remove(e);
        nb = null;
        break;
      }
    }
    add_edge(na);
    add_edge(nb);
  }
}


void add_edge(Edge e) {
  if (e != null) {
    edges.add(e);
    outer_edges.add(e);
  }
}

PVector closest_point(ArrayList<PVector> others, PVector p ) {
  float mindist = Float.MAX_VALUE;
  PVector closest = null;
  for (PVector o : others) {
    if (o != p) {
      float dist = p.dist(o);
      if (dist < mindist) {
        closest = o;
        mindist = dist;
      }
    }
  }
  return closest;
}



Edge closest_point(ArrayList<PVector> others, ArrayList<Edge> edges) {
  float mindist = Float.MAX_VALUE;
  Edge with_closest = null;
  for (Edge e : edges) {
    for (PVector o : others) {
      if (o != e.a && o != e.b) {
        float dist = e.normal_dist(o);
        if (dist < mindist) {
          with_closest = e;
          with_closest.neighbour = o;
          with_closest.neighbour_dist = dist;
          mindist = dist;
        }
      }
    }
  }
  return with_closest;
}

Edge closest_point(ArrayList<Edge> edges) {
  float mindist = Float.MAX_VALUE;
  Edge with_closest = null;
  for (Edge e : edges) {
    for (Edge f : edges) {
      if (!f.equals(e)) {
        float dist_a = e.normal_dist(f.a);
        float dist_b = e.normal_dist(f.b);
        if (dist_a < dist_b) {
          PVector o = f.a;
          if (o != e.a && o != e.b) {
            float dist = e.normal_dist(o);
            if (dist < mindist) {
              with_closest = e;
              with_closest.neighbour = o;
              with_closest.neighbour_dist = dist;
              mindist = dist;
            }
          }
        } else {
          PVector o = f.b;
          if (o != e.a && o != e.b) {
            float dist = e.normal_dist(o);
            if (dist < mindist) {
              with_closest = e;
              with_closest.neighbour = o;
              with_closest.neighbour_dist = dist;
              mindist = dist;
            }
          }
        }
      }
    }
  }
  return with_closest;
}

//PVector closest_point(ArrayList<PVector> others, PVector p1, PVector p2) {
//  float mindist = Float.MAX_VALUE;
//  PVector closest = null;
//  for (PVector o : others) {
//    float dist = min(p1.dist(o), p2.dist(o));
//    if (dist < mindist) {
//      closest = o;
//      mindist = dist;
//    }
//  }
//  return closest;
//}
