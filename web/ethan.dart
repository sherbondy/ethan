import 'dart:html';
import 'dart:math';
import 'package:web_ui/web_ui.dart';

void drawLines(CanvasRenderingContext2D context, 
               {num spacing: 10, num width: 100, num height: 100}) {  
  for (num y = 0; y < height; y += spacing) {
    context..moveTo(0, y)
           ..lineTo(width, y);
  }
}

void drawSqLines(CanvasRenderingContext2D context, num length, 
                 {num spacing: 10}) {
  drawLines(context, spacing: spacing, height: length, width: length);
}

void drawDiagonals(CanvasRenderingContext2D context, 
                   {num spacing: 10, num length: 100}) {      
  for (num pos = 0; pos < length; pos += spacing) {
    context..moveTo(0, pos)
           ..lineTo(length - pos, length);
  }
}

void drawDiagonalSquare(CanvasRenderingContext2D context, 
                        {num spacing: 10, num length: 100}) {
  drawDiagonals(context, spacing: spacing, length: length);

  transact(context, (){
    context..translate(length, length)
           ..scale(-1,-1);
    drawDiagonals(context, spacing: spacing, length: length);
  });
}

void drawL(CanvasRenderingContext2D context, 
           {num spacing: 10, num width: 100, num height: 100}) {
  num smallSide = min(width, height);
  
  for (num pos = 0; pos < smallSide; pos += spacing) {
    context..moveTo(width, pos)
           ..lineTo(pos, pos)
           ..lineTo(pos, height);
  }
}

void drawV(CanvasRenderingContext2D context, 
           {num spacing: 10, num width: 100, num height: 100}) {
  num smallSide = min(width, height);
  num tanTheta = width/height;
  num theta = atan(tanTheta);
  
  for (num pos = 0; pos < smallSide/2; pos += spacing) {
    num triWidth = width - pos - pos/cos(theta);
    num triHeight = triWidth/tanTheta;
    context..moveTo(triWidth + pos, height)
           ..lineTo(pos, height - triHeight)
           ..lineTo(pos, height);
  }
}

void drawN(CanvasRenderingContext2D context, 
           {num spacing: 10, num length: 100}) {
  drawV(context, spacing: spacing, width: length, height: length);
  // right/top of N
  transact(context, (){
    rotateCenter(context, PI, length, length, (){
      drawV(context, spacing: spacing, width: length, height: length);
    });
  });
}

void drawHalfO(CanvasRenderingContext2D context, 
               {num spacing: 10, num width: 100, num height: 100}) {
  drawL(context, spacing: spacing, width: width/2, height: height);
  // right half
  transact(context, (){
    context..translate(width, 0)
           ..scale(-1, 1);
    drawL(context, spacing: spacing, width: width/2, height: height);
  });
}

void drawO(CanvasRenderingContext2D context, 
           {num spacing: 10, num length: 100}) {
  drawRect(context, spacing: spacing, width: length, height: length);
}

void drawRect(CanvasRenderingContext2D context, 
              {num spacing: 10, num width: 100, num height: 100}) {
  drawHalfO(context, spacing: spacing, width: width, height: height/2);
  // bottom
  transact(context, (){
    context..translate(0, height)
           ..scale(1, -1);
    drawHalfO(context, spacing: spacing, width: width, height: height/2);
  });
}

void drawA(CanvasRenderingContext2D context, 
           {num spacing: 10, num length: 100}) {
  num height = length/2;
  drawRect(context, spacing: spacing, width: length, height: height);
  
  context.translate(0, height);
  drawHalfO(context, spacing: spacing, width: length, height: height);
}

void drawH(CanvasRenderingContext2D context, 
           {num spacing: 10, num length: 100}) {
  num height = length/2;
  txRotateCenter(context, PI, length, height, (){
    drawHalfO(context, spacing: spacing, width: length, height: height);
  });
  
  context.translate(0, height);
  drawHalfO(context, spacing: spacing, width: length, height: height);
}

void drawT(CanvasRenderingContext2D context, 
           {num spacing: 10, num length: 100}) {
  num width = length/2;
  
  context.translate(width, 0);
  transact(context, (){
    context.scale(-1, 1);
    drawL(context, spacing: spacing, width: width, height: length);
  });
  
  drawL(context, spacing: spacing, width: width, height: length);
}

void drawE(CanvasRenderingContext2D context, 
           {num spacing: 10, num length: 100}) {
  num width = length/2;
  
  rotateCenter(context, -PI/2, length, length, (){
    drawHalfO(context, spacing: spacing, width: width, height: length);
    context.translate(width, 0);
    drawHalfO(context, spacing: spacing, width: width, height: length);
  });
}

void drawP(CanvasRenderingContext2D context, 
           {num spacing: 10, num length: 100}) {
  num height = length/2;
  drawRect(context, spacing: spacing, width: length, height: height);
  
  context.translate(0, height);
  drawL(context, spacing: spacing, width: length, height: height);
}

void drawS(CanvasRenderingContext2D context, 
           {num spacing: 10, num length: 100}) {
  num width = length/2;
  
  rotateCenter(context, PI/2, length, length, (){
    transact(context, (){
      context..scale(1, -1)
             ..translate(0, -length);
      drawHalfO(context, spacing: spacing, width: width, height: length);
    });
    
    context.translate(width, 0);
    drawHalfO(context, spacing: spacing, width: width, height: length);
  });
}

void drawB(CanvasRenderingContext2D context, 
           {num spacing: 10, num length: 100}) {
  num height = length/2;
  drawRect(context, spacing: spacing, width: length, height: height);
  
  context.translate(0, height);
  drawRect(context, spacing: spacing, width: length, height: height);
}

void drawR(CanvasRenderingContext2D context, 
           {num spacing: 10, num length: 100}) {
  num height = length/2;
  drawRect(context, spacing: spacing, width: length, height: height);
  
  context.translate(0, height);
  drawHalfO(context, spacing: spacing, width: length/2, height: height);
  
  context.translate(length/2, 0);
  drawL(context, spacing: spacing, width: length/2, height: height);  
}

void drawD(CanvasRenderingContext2D context, 
           {num spacing: 10, num length: 100}) {
  num height = length/2;
  transact(context, (){
    context.translate(-length, 0);
    rotateCenter(context, -PI/2, 2*length, 0, (){
      drawHalfO(context, spacing: spacing, width: length, height: height);
    });
  });
 
  context.translate(length/2, 0);
  drawDiagonalSquare(context, spacing: spacing, length: height);
  
  context..translate(0, length)
         ..scale(1, -1);
  drawDiagonalSquare(context, spacing: spacing, length: height);  
}

void drawY(CanvasRenderingContext2D context, 
           {num spacing: 10, num length: 100}) {
  num height = length/2;
  transact(context, (){
    context..translate(0, height)
           ..scale(1, -1);
    drawHalfO(context, spacing: spacing, width: length, height: height);
  });
  
  context.translate(height, height);
  transact(context, (){
    context.scale(-1, 1);
    drawL(context, spacing: spacing, width: height, height: height);
  });
  
  drawL(context, spacing: spacing, width: height, height: height);
}

num imageCount = 92;
// spacing is not actually used
void drawBrains(CanvasRenderingContext2D context, 
                {num spacing: 10, num length: 100}) {
  ImageElement brainImage = new ImageElement();
  brainImage.src = "brain/image_05-21-2013_${rand.nextInt(imageCount)}.png";
  num currentX = xTranslation;
  num currentY = yTranslation;
  
  brainImage.onLoad.listen((event) =>
    context.drawImageScaled(brainImage, currentX, currentY, length, length));
}

// GENERAL FUNCTIONS

void clearContext(CanvasRenderingContext2D context) {
  context..fillRect(0, 0, context.canvas.width, context.canvas.height);
}

void transact(CanvasRenderingContext2D context, Function fn) {
  context.save();
  fn();
  context.restore();
}

// pass in a canvas context, the rotation angle, and the width and height of the object drawn by drawFn
void rotateCenter(CanvasRenderingContext2D context, 
                  num angle, num width, num height, Function drawFn) {
  context..translate(width/2, height/2)
         ..rotate(angle)
         ..translate(-width/2, -height/2);
  drawFn();
}

// wrap rotation in a transaction for convenience
void txRotateCenter(CanvasRenderingContext2D context, 
                    num angle, num width, num height, Function drawFn) {
  transact(context, (){
    rotateCenter(context, angle, width, height, drawFn);
  });
}

Map<String, Function> letterFunctions = 
{
  "a": drawA,
  "b": drawB,
  "d": drawD,
  "e": drawE,
  "h": drawH,
  "o": drawO,
  "n": drawN,
  "p": drawP,
  "r": drawR,
  "s": drawS,
  "t": drawT,
  "y": drawY,
  "*": drawBrains
};

num blockSize = 80;
num innerSpacing = 8;
num lineWidth = 2;
num margin = 16;
num xTranslation = 0;
num yTranslation = 0;
num get translation => blockSize + margin;
List<String> name = ["ethan*", "p*sher", "*bondy"];
List<List<Map<String, num>>> currentColors = [];
List<List<Map<String, num>>> nextColors = [];
Random rand = new Random();

Map<String, num> randomColor() {
  return {"r": rand.nextInt(255),
          "g": rand.nextInt(255),
          "b": rand.nextInt(255)};
}

bool sameColors(Map<String, num> a, Map<String, num> b) {
  bool same = true;
  a.forEach((k, v) {
    if (!b.containsKey(k) || v != b[k]) {
      same = false;
    }
  });
  return same;
}

void initializeColors(num nameLength) {
  for (num i = 0; i < nameLength; i++) {
    currentColors.add([]);
    nextColors.add([]);
  }
}

void updateColor(num i, num j) {
  // handle color transition
  if (currentColors[i].length <= j) {
    currentColors[i].add(randomColor());
    nextColors[i].add(randomColor());
  }
  
  Map<String, num> currentColor = currentColors[i][j];
  Map<String, num> nextColor = nextColors[i][j];
  
  // should really just use hex literals
  if (sameColors(currentColor, nextColor)) {
    nextColors[i][j] = randomColor();
  } else {
    nextColor.forEach((k, v) {
      if (currentColor[k] < v) {
        currentColor[k] += 1;
      } else if (currentColor[k] > v) {
        currentColor[k] -= 1;
      }
      currentColors[i][j] = currentColor;
    });
  }
}

void drawName(CanvasRenderingContext2D context, List<String> name, num delta) {
  transact(context, () {
    context.lineWidth = lineWidth;
      
    num maxLength = name.fold(0, (a, b) => max(a, b.length));
    num width =  maxLength * translation;
    num height = name.length * translation;
    num offsetX = (context.canvas.width - width)/2;
    num offsetY = (context.canvas.height - height)/2;
  
    //Pattern vowel = new RegExp("[aeiou]");
    //context.translate(offsetX, offsetY);
    
    // initialize currentColors and nextColors
    if (currentColors.length != name.length) {
      initializeColors(name.length);
    }
    
    for (num i = 0; i < name.length; i++) {
      String word = name[i];
      
      for (num j = 0; j < word.length; j++) {
        String letter = word.substring(j, j+1);
        Function drawLetter = letterFunctions[letter];
        
        xTranslation = offsetX + j*translation;
        yTranslation = offsetY + i*translation;
        
        updateColor(i, j);
        Map<String, num> currentColor = currentColors[i][j];
                        
        transact(context, () {        
          context..translate(xTranslation, yTranslation)
                 ..beginPath()
                 ..setStrokeColorRgb(currentColor["r"], 
                                     currentColor["g"], 
                                     currentColor["b"], 1);
          
          if (letter != "*") {
            // make the background the inverse of the perceived brightness of the stroke
            num perceivedBrightness = (0.299*currentColor["r"] + 
                                       0.587*currentColor["g"] + 
                                       0.114*currentColor["b"]);
            num bgBrightness = 255 - perceivedBrightness.ceil();
            num bgLength = blockSize + 2*lineWidth;
            context..setFillColorRgb(bgBrightness, bgBrightness, bgBrightness, 1)
                   ..fillRect(-lineWidth, -lineWidth, bgLength, bgLength);
            drawLetter(context, length: blockSize, spacing: innerSpacing);
          } else if (delta.floor() % 60 == 0) {
            drawLetter(context, length: blockSize, spacing: innerSpacing);
          }
          context.stroke();
        });
      }
    }
  });
  
  window.animationFrame.then((num delta){
    drawName(context, name, delta);
  });
}

void main() {
  CanvasElement canvas = query("#ethan");
  CanvasRenderingContext2D context = canvas.getContext("2d");
  context.fillStyle = "#000000";
  clearContext(context);

  // canvas.onClick.listen((event) => drawName(context, name));
  
  window.animationFrame.then((num delta) => drawName(context, name, delta));
}
