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

// spacing is not actually used
num imageCount = 92;
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
  context..setFillColorRgb(255, 255, 255, 1)
         ..fillRect(0, 0, context.canvas.width, context.canvas.height);
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
num margin = 16;
num xTranslation = 0;
num yTranslation = 0;
num get translation => blockSize + margin;
List<String> name = ["ethan*", "p*sher", "*bondy"];
Random rand = new Random();

void drawName(CanvasRenderingContext2D context, List<String> name) {
  transact(context, () {
    context.lineWidth = 2;
    clearContext(context);
      
    num maxLength = name.fold(0, (a, b) => max(a, b.length));
    num width =  maxLength * translation;
    num height = name.length * translation;
    num offsetX = (context.canvas.width - width)/2;
    num offsetY = (context.canvas.height - height)/2;
  
    //Pattern vowel = new RegExp("[aeiou]");
//    context.translate(offsetX, offsetY);
    
    for (num i = 0; i < name.length; i++) {
      String word = name[i];
      for (num j = 0; j < word.length; j++) {
        String letter = word.substring(j, j+1);
        Function drawLetter = letterFunctions[letter];
        
        xTranslation = offsetX + j*translation;
        yTranslation = offsetY + i*translation;
        
        transact(context, () {        
          context..translate(xTranslation, yTranslation)
                 ..beginPath()
                 ..setStrokeColorRgb(rand.nextInt(255), rand.nextInt(255), rand.nextInt(255), 1);
          drawLetter(context, length: blockSize, spacing: innerSpacing);
          context.stroke();  
        });
      }
    }
  });
}

void main() {
  CanvasElement canvas = query("#ethan");
  CanvasRenderingContext2D context = canvas.getContext("2d");

  canvas.onClick.listen((event) => drawName(context, name));
  
  drawName(context, name);
}
