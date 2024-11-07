// Lengths of pendulum arms
float len1 = 100;
float len2 = 100;
float len3 = 100;

// Masses of pendulum bobs
float m1 = 10;
float m2 = 10;
float m3 = 10;

// Angles and angular velocities
float theta1 = PI / 2;
float theta2 = PI / 2;
float theta3 = PI / 2;
float omega1 = 0;
float omega2 = 0;
float omega3 = 0;

// Acceleration due to gravity
float g = 9.81;

// Variables for simulation
float lastTime;
float deltaTime;

// Array to store previous positions of the third pendulum bob
ArrayList<PVector> positions = new ArrayList<PVector>();

void setup() {
  size(800, 600);
}

void draw() {
  background(255);
  updateDeltaTime();
  calculateAngles();
  drawPendulum();
}

void updateDeltaTime() {
  float currentTime = millis() / 100.0;
  deltaTime = currentTime - lastTime;
  lastTime = currentTime;
}

void calculateAngles() {
  float num1 = -g * (2 * m1 + m2 + m3) * sin(theta1);
  float num2 = -m2 * g * sin(theta1 - 2 * theta2);
  float num3 = -2 * sin(theta1 - theta2) * m2;
  float num4 = omega2 * omega2 * len2 + omega1 * omega1 * len1 * cos(theta1 - theta2);
  float den = len1 * (2 * m1 + m2 + m3 - m2 * cos(2 * theta1 - 2 * theta2));
  
  float alpha1 = (num1 + num2 + num3 * num4) / den;
  
  num1 = 2 * sin(theta1 - theta2);
  num2 = (omega1 * omega1 * len1 * (m1 + m2 + m3));
  num3 = g * (m1 + m2 + m3) * cos(theta1);
  num4 = omega2 * omega2 * len2 * m2 * cos(theta1 - theta2);
  den = len2 * (2 * m1 + m2 + m3 - m2 * cos(2 * theta1 - 2 * theta2));
  
  float alpha2 = (num1 * (num2 + num3 + num4)) / den;

  num1 = 2 * sin(theta2 - theta3);
  num2 = (omega2 * omega2 * len2 * (m2 + m3));
  num3 = g * (m2 + m3) * cos(theta2);
  den = len3 * (2 * m2 + m3 - m3 * cos(2 * theta2 - 2 * theta3));
  
  float alpha3 = (num1 * (num2 + num3)) / den;

  omega1 += alpha1 * deltaTime;
  omega2 += alpha2 * deltaTime;
  omega3 += alpha3 * deltaTime;
  theta1 += omega1 * deltaTime;
  theta2 += omega2 * deltaTime;
  theta3 += omega3 * deltaTime;
}

void drawPendulum() {
  float scaleFactor = 1; // Scale factor for drawing

  // Coordinates of the pivot point
  float pivotX = width/2;
  float pivotY = height/2;

  float x1 = pivotX + len1 * sin(theta1) * scaleFactor;
  float y1 = pivotY + len1 * cos(theta1) * scaleFactor;

  float x2 = x1 + len2 * sin(theta2) * scaleFactor;
  float y2 = y1 + len2 * cos(theta2) * scaleFactor;

  float x3 = x2 + len3 * sin(theta3) * scaleFactor;
  float y3 = y2 + len3 * cos(theta3) * scaleFactor;

  stroke(0);
  strokeWeight(2);

  // First pendulum arm
  line(pivotX, pivotY, x1, y1);

  // Second pendulum arm
  line(x1, y1, x2, y2);

  // Third pendulum arm
  line(x2, y2, x3, y3);

  // First pendulum bob
  fill(0);
  ellipse(x1, y1, m1, m1);

  // Second pendulum bob
  fill(0);
  ellipse(x2, y2, m2, m2);

  // Third pendulum bob
  fill(0);
  ellipse(x3, y3, m3, m3);

  // Store current position of the third pendulum bob
  PVector pos = new PVector(x3, y3);
  positions.add(pos);
  if (positions.size() > 10) positions.remove(0);

  // Draw thin red line representing the path of the third pendulum bob
  stroke(255, 0, 0); // Red color
  strokeWeight(1);
  noFill();
  beginShape();
  for (PVector p : positions) {
    vertex(p.x, p.y);
  }
  endShape();
}
