void line(Edge e) {
  line(e.a, e.b);
}

void line(PVector a, PVector b) {
  line(a.x, a.y, b.x, b.y);
}



float sign(float x) {
  if ( x > 0) {
    return 1;
  } else if (x < 0 ) {
    return -1;
  } else {
    return 0;
  }
}
