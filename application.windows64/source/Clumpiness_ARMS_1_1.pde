import controlP5.*;
import javax.swing.*; 

int[] pX =  new int [0];
int[] pY =  new int [0];
int numPoints = 0;

float[] dists;
int[] pOne;
int[] pTwo;
int[] fVal;

int menuState = -1;

int mBounce = 0;
int kBounce = 0;
int intb = 0;

ControlP5 cp5;
String txtIn;
int MaxLength = 50;
int txtInter = 0;
int txtBG = 0;

PImage platePhoto;
String photoPath = "plate.jpg";
String outputPath = "";
float imgScale;
int rSizeX;
int rSizeY;

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

void setup() {
  // size(displayWidth, displayHeight);
  fullScreen();
  background(200);
  textAlign(CENTER, CENTER);
  
    PFont font = createFont("arial", 20);
 
  cp5 = new ControlP5(this);
 
  cp5 = new ControlP5(this);
  cp5.addTextfield("textInput_1").setPosition(width/2, 250).setSize(100, 20).setAutoClear(false).hide().setLabelVisible(false);
  cp5.addBang("Submit").setPosition(width/2, 290).setSize(40, 15).hide().setLabelVisible(false);  
  
  // Javax.swing custom function
  final JFileChooser fc = new JFileChooser(); 
  int returnVal = fc.showOpenDialog(fc);
  
  if (returnVal == JFileChooser.APPROVE_OPTION) { 
    File file = fc.getSelectedFile(); 
    photoPath = file.getAbsolutePath();
  } 
  else { 
    println("Cancelled.");
  }
  
  platePhoto = loadImage(photoPath);
  
  println("loaded");
  
  imgScale = (float)((float)height / (float)platePhoto.height);
  if (imgScale > (float)((float)width / (float)platePhoto.width)) {
    imgScale = (float)((float)width / (float)platePhoto.width);
  }
  rSizeX = (int)((float)platePhoto.width*(float)imgScale);
  rSizeY = (int)((float)platePhoto.height*(float)imgScale);
  platePhoto.resize(rSizeX, rSizeY);
}

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

void draw() {
  background(200);
  image(platePhoto, 0, 0);
  
  mousePoint();
  
  for (int i = 0; i < numPoints; i ++) {
    stroke(255, 0, 0);
    strokeWeight(5);
    point(pX[i], pY[i]);
  }
}

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

void mousePoint() {
  if (keyPressed && key == 'd' && kBounce == 0 && pX.length != 0) {
    pX = shorten(pX);
    pY = shorten(pY);
    kBounce = 1;
  }
  //if (keyPressed && key == 's' && kBounce == 0 && pX.length != 0) {
  //  clumpCalc();
  //  kBounce = 1;
  //}
  if (keyPressed && key == 'm' && kBounce == 0) {
    menuState *= -1;
    kBounce = 1;
  }
  if (menuState == 1) {
    menuDraw();
  }
  if (!keyPressed && kBounce == 1) {
    kBounce = 0;
  }
  if (mousePressed && mBounce == 0 && !keyPressed && txtInter == 0) {
    pX = append(pX, mouseX);
    pY = append(pY, mouseY);
    mBounce = 1;
  }
  if (!mousePressed && mBounce == 1) {
    mBounce = 0;
  }
  numPoints = pX.length;
  if (txtBG == 1) {
    fill(#0B6DD3, 150);
    strokeWeight(3);
    stroke(#003F81, 175);
    rect((width/2)-20, 230 , 140 , 110);
  }
}

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

void menuDraw() {
  fill(150, 150, 180, 200);
  strokeWeight(2);
  stroke(140, 140, 180, 240);
  rect(-5, -5, width + 5, 25);
  stroke(100, 100, 140, 200);
  line(150, -5, 150, 20);
  line(300, -5, 300, 20);
  line(450, -5, 450, 20);
  line(600, -5, 600, 20);
  line(750, -5, 750, 20);
  textSize(14);
  noStroke();
  fill(50);
  text("Save Data to .txt File", 75, 8.5);
  text("Clear All Points", 225, 8.5);
  text("Open New Image", 375, 8.5);
  text("Set Max Distance", 525, 8.5);
  text("Close Program", 675, 8.5);
  String mL = "Max Length: ";
  mL += MaxLength;
  text(mL, 825, 8.5);
  
  if (mouseX > 0 && mouseX < 150 && mouseY > 0 && mouseY < 20 && mousePressed && mBounce == 0) {
    clumpCalc();
    mBounce = 1;
  }
  if (mouseX > 150 && mouseX < 300 && mouseY > 0 && mouseY < 20 && mousePressed && mBounce == 0) {
    pX = new int [0];
    pY = new int [0];
    mBounce = 1;
  }
  if (mouseX > 300 && mouseX < 450 && mouseY > 0 && mouseY < 20 && mousePressed && mBounce == 0) {
    // Javax.swing custom function
    final JFileChooser fc = new JFileChooser(); 
    int returnVal = fc.showOpenDialog(fc);
    
    if (returnVal == JFileChooser.APPROVE_OPTION) { 
      File file = fc.getSelectedFile(); 
      photoPath = file.getAbsolutePath();
    } 
    else { 
      println("Cancelled.");
    }
    
    platePhoto = loadImage(photoPath);
    imgScale = (float)((float)height / (float)platePhoto.height);
    if (imgScale > (float)((float)width / (float)platePhoto.width)) {
      imgScale = (float)((float)width / (float)platePhoto.width);
    }
    rSizeX = (int)((float)platePhoto.width*(float)imgScale);
    rSizeY = (int)((float)platePhoto.height*(float)imgScale);
    platePhoto.resize(rSizeX, rSizeY);
    mBounce = 1;
  }
  if (mouseX > 450 && mouseX < 600 && mouseY > 0 && mouseY < 20 && mousePressed && mBounce == 0) {
    txtInter = 1;
    cp5.get(Textfield.class,"textInput_1").show().setLabelVisible(false);
    cp5.get(Bang.class,"Submit").show().setLabelVisible(true);
    txtBG = 1;
    mBounce = 1;
  }
  if (mouseX > 600 && mouseX < 750 && mouseY > 0 && mouseY < 20 && mousePressed && mBounce == 0) {
    exit();
    mBounce = 1;
  }
  if (!mousePressed && mBounce == 1) {
    mBounce = 0;
  }
}

public void Submit() {
  println(cp5.get(Textfield.class,"textInput_1").getText());
  MaxLength = Integer.parseInt(cp5.get(Textfield.class,"textInput_1").getText());
  cp5.get(Textfield.class,"textInput_1").hide();
  cp5.get(Bang.class,"Submit").hide();
  txtInter = 0;
  txtBG = 0;
  mBounce = 1;
}

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

void clumpCalc() {
  
  dists = new float[0];
  pOne = new int[0];
  pTwo = new int[0];
  fVal = new int[0];
  
  for (int a = 0; a < pX.length; a++) {
    for (int b = pX.length-1; b > a; b--) {
      dists = append(dists, sqrt(abs(pow(pX[b]-pX[a], 2) + pow(pY[b]-pY[a], 2))));
      pOne = append(pOne, a);
      pTwo = append(pTwo, b);
      
      if (sqrt(abs(pow(pX[b]-pX[a], 2) + pow(pY[b]-pY[a], 2))) < MaxLength) {
        fVal = append(fVal, 1);
      }
      else {
        fVal = append(fVal, 0);
      }
    }
  }
  saveData();
}

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

void saveData() {
  String[] arrayOut = new String[0];
  String out = "";
  out += "Max Length: ";
  out += MaxLength;
  arrayOut = append(arrayOut, out);
  
  for (int i = 0; i < fVal.length; i++) {
    out = "";
    out += i;
    out += " | ";
    out += pOne[i];
    out += " | ";
    out += pTwo[i];
    out += " | ";
    out += dists[i];
    out += " | ";
    out += fVal[i];
    
    arrayOut = append(arrayOut, out);
  }
  
  JFrame parentFrame = new JFrame();
 
  JFileChooser fileChooser = new JFileChooser();
  fileChooser.setDialogTitle("Specify a file to save");   
   
  int userSelection = fileChooser.showSaveDialog(parentFrame);
   
  if (userSelection == JFileChooser.APPROVE_OPTION) {
      File fileToSave = fileChooser.getSelectedFile();
      System.out.println("Save as file: " + fileToSave.getAbsolutePath());
      outputPath = fileToSave.getAbsolutePath();
  }
  
  saveStrings(outputPath, arrayOut);
}