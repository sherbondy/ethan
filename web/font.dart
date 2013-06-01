library font;

import 'dart:html';
import 'dart:math';

import 'canvas.dart';

// see if two colors are identical.
// really just a generic map comparator.
bool sameColors(Map<String, num> a, Map<String, num> b) {
  bool same = true;
  a.forEach((k, v) {
    if (!b.containsKey(k) || v != b[k]) {
      same = false;
    }
  });
  return same;
}

class FontParams {
  num xTranslation, yTranslation = 0;
  num blockSize = 80;
  num innerSpacing = 8;
  num lineWidth = 2;
  num margin = 16;
  
  num get translation => blockSize + margin;
  
  List<String> _name;
  
  // colors are maps of {"r":0-255, "g": 0-255, "b": 0-255}
  List<List<Map<String, num>>> currentColors = [];
  List<List<Map<String, num>>> nextColors = [];
  
  Random rand = new Random();
  
  Map<String, num> randomColor() {
    return {"r": rand.nextInt(255),
      "g": rand.nextInt(255),
      "b": rand.nextInt(255)};
  }
  
  void initializeColors() {
    for (num i = 0; i < name.length; i++) {
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
  
  List<String> get name => _name;
  set name(List<String> theName) {
    _name = theName;
    initializeColors();
  }
}

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

void drawHalfT(CanvasRenderingContext2D context, 
           {num spacing: 10, num width: 100, num height: 100}) {
  num smallSide = min(width, height);
  
  for (num pos = 0; pos < smallSide; pos += spacing) {
    context..moveTo(width, pos)
           ..lineTo(pos, pos)
           ..lineTo(pos, height);
  }
}

void drawV(CanvasRenderingContext2D context, 
           {num spacing: 10, num width: 100, num height: 100, FontParams params}) {
  num smallSide = min(width, height);
  num tanTheta = width/height;
  num theta = atan(tanTheta);
  num posCutoff = smallSide/2 - 2*params.lineWidth;
  
  for (num pos = 0; pos < posCutoff; pos += spacing) {
    num triWidth = width - pos - pos/cos(theta);
    num triHeight = triWidth/tanTheta;
    context..moveTo(triWidth + pos, height)
           ..lineTo(pos, height - triHeight)
           ..lineTo(pos, height);
  }
}

void drawN(CanvasRenderingContext2D context, 
           {num spacing: 10, num length: 100, FontParams params}) {
  drawV(context, spacing: spacing, width: length, height: length, params: params);
  // right/top of N
  transact(context, (){
    rotateCenter(context, PI, length, length, (){
      drawV(context, spacing: spacing, width: length, height: length, params:params);
    });
  });
}

void drawHalfO(CanvasRenderingContext2D context, 
               {num spacing: 10, num width: 100, num height: 100}) {
  drawHalfT(context, spacing: spacing, width: width/2, height: height);
  // right half
  transact(context, (){
    context..translate(width, 0)
           ..scale(-1, 1);
    drawHalfT(context, spacing: spacing, width: width/2, height: height);
  });
}

void drawO(CanvasRenderingContext2D context, 
           {num spacing: 10, num length: 100, FontParams params}) {
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
           {num spacing: 10, num length: 100, FontParams params}) {
  num height = length/2;
  drawRect(context, spacing: spacing, width: length, height: height);
  
  context.translate(0, height);
  drawHalfO(context, spacing: spacing, width: length, height: height);
}

void drawH(CanvasRenderingContext2D context, 
           {num spacing: 10, num length: 100, FontParams params}) {
  num height = length/2;
  txRotateCenter(context, PI, length, height, (){
    drawHalfO(context, spacing: spacing, width: length, height: height);
  });
  
  context.translate(0, height);
  drawHalfO(context, spacing: spacing, width: length, height: height);
}

void drawT(CanvasRenderingContext2D context, 
           {num spacing: 10, num length: 100, FontParams params}) {
  num width = length/2;
  
  context.translate(width, 0);
  transact(context, (){
    context.scale(-1, 1);
    drawHalfT(context, spacing: spacing, width: width, height: length);
  });
  
  drawHalfT(context, spacing: spacing, width: width, height: length);
}

void drawU(CanvasRenderingContext2D context, 
           {num spacing: 10, num length: 100, FontParams params}) {
  txRotateCenter(context, PI, length, length, (){
    drawHalfO(context, spacing: spacing, width: length, height: length);
  });
}

void drawJ(CanvasRenderingContext2D context, 
           {num spacing: 10, num length: 100, FontParams params}) {
  num width = length/2;
  
  txRotateCenter(context, PI/2, width, width, (){
    drawHalfO(context, spacing: spacing, width: length, height: width);
  });
  
  transact(context, (){
    context.translate(width, 0);
    drawHalfT(context, spacing: spacing, width: width, height: length);
  });
}

void drawE(CanvasRenderingContext2D context, 
           {num spacing: 10, num length: 100, FontParams params}) {
  num width = length/2;
  
  rotateCenter(context, -PI/2, length, length, (){
    drawHalfO(context, spacing: spacing, width: width, height: length);
    context.translate(width, 0);
    drawHalfO(context, spacing: spacing, width: width, height: length);
  });
}

void drawF(CanvasRenderingContext2D context, 
           {num spacing: 10, num length: 100, FontParams params}) {
  num width = length/2;
  
  txRotateCenter(context, -PI/2, length, length, (){
    context.translate(width, 0);
    drawHalfO(context, spacing: spacing, width: width, height: length);
  });
  
  transact(context, (){
    context.translate(0, width);
    drawHalfT(context, spacing: spacing, width: length, height: width);
  });
}

void drawP(CanvasRenderingContext2D context, 
           {num spacing: 10, num length: 100, FontParams params}) {
  num height = length/2;
  drawRect(context, spacing: spacing, width: length, height: height);
  
  context.translate(0, height);
  drawHalfT(context, spacing: spacing, width: length, height: height);
}

void drawS(CanvasRenderingContext2D context, 
           {num spacing: 10, num length: 100, FontParams params}) {
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
           {num spacing: 10, num length: 100, FontParams params}) {
  num height = length/2;
  drawRect(context, spacing: spacing, width: length, height: height);
  
  context.translate(0, height);
  drawRect(context, spacing: spacing, width: length, height: height);
}

void drawR(CanvasRenderingContext2D context, 
           {num spacing: 10, num length: 100, FontParams params}) {
  num height = length/2;
  drawRect(context, spacing: spacing, width: length, height: height);
  
  context.translate(0, height);
  drawHalfO(context, spacing: spacing, width: length/2, height: height);
  
  context.translate(length/2, 0);
  drawHalfT(context, spacing: spacing, width: length/2, height: height);  
}

void drawD(CanvasRenderingContext2D context, 
           {num spacing: 10, num length: 100, FontParams params}) {
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
           {num spacing: 10, num length: 100, FontParams params}) {
  num height = length/2;
  transact(context, (){
    context..translate(0, height)
           ..scale(1, -1);
    drawHalfO(context, spacing: spacing, width: length, height: height);
  });
  
  context.translate(height, height);
  transact(context, (){
    context.scale(-1, 1);
    drawHalfT(context, spacing: spacing, width: height, height: height);
  });
  
  drawHalfT(context, spacing: spacing, width: height, height: height);
}

void drawC(CanvasRenderingContext2D context, 
           {num spacing: 10, num length: 100, FontParams params}) {
  txRotateCenter(context, -PI/2, length, length, (){
    drawHalfO(context, spacing: spacing, width: length, height: length);
  });
}

void drawI(CanvasRenderingContext2D context, 
           {num spacing: 10, num length: 100, FontParams params}) {
  txRotateCenter(context, -PI/2, length, length, (){
    drawH(context, spacing: spacing, length: length);
  });
}

void drawL(CanvasRenderingContext2D context, 
           {num spacing: 10, num length: 100, FontParams params}) {
  transact(context, (){
    context..translate(0, length)
           ..scale(1, -1);
    drawHalfT(context, spacing: spacing, width: length, height: length);
  });
}

void drawM(CanvasRenderingContext2D context, 
           {num spacing: 10, num length: 100, FontParams params}) {
  txRotateCenter(context, PI/2, length, length, (){
    drawE(context, spacing: spacing, length: length);
  });
}

  
num imageCount = 92;
// spacing is not actually used
void drawBrains(CanvasRenderingContext2D context, 
                {num spacing: 10, num length: 100, FontParams params}) {
  ImageElement brainImage = new ImageElement();
  brainImage.src = "brain/image_05-21-2013_${params.rand.nextInt(imageCount)}.png";
  num currentX = params.xTranslation;
  num currentY = params.yTranslation;
  
  brainImage.onLoad.listen((event) =>
    context.drawImageScaled(brainImage, currentX, currentY, length, length));
}

Map<String, Function> letterFunctions = 
{
  "a": drawA,
  "b": drawB,
  "c": drawC,
  "d": drawD,
  "e": drawE,
  "f": drawF,
  "h": drawH,
  "i": drawI,
  "j": drawJ,
  "l": drawL,
  "m": drawM,
  "n": drawN,
  "o": drawO,
  "p": drawP,
  "r": drawR,
  "s": drawS,
  "t": drawT,
  "u": drawU,
  "y": drawY,
  "*": drawBrains
};