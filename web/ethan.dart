import 'dart:html';
import 'dart:math';
import 'package:web_ui/web_ui.dart';

/**
 * Learn about the Web UI package by visiting
 * http://www.dartlang.org/articles/dart-web-components/.
 */

void drawLines(CanvasRenderingContext2D context, {num spacing: 10, num height: 100, num width: 100}) {  
  for (num y = 0; y < height; y += spacing) {
    context..moveTo(0, y)
           ..lineTo(width, y);
  }
}

void drawSqLines(CanvasRenderingContext2D context, num length, {num spacing: 10}) {
  drawLines(context, spacing: spacing, height: length, width: length);
}

void drawL(CanvasRenderingContext2D context, {num spacing: 10, num width: 100, num height: 100}) {
  num smallSide = min(width, height);
  
  for (num pos = 0; pos < smallSide; pos += spacing) {
    context..moveTo(width, pos)
           ..lineTo(pos, pos)
           ..lineTo(pos, height);
  }
}

void drawV(CanvasRenderingContext2D context, {num spacing: 10, num width: 100, num height: 100}) {
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

void drawN(CanvasRenderingContext2D context, {num spacing: 10, num length: 100}) {
  drawV(context, spacing: spacing, width: length, height: length);
  context.stroke();
  // right/top of N
  transact(context, (){
    rotateCenter(context, PI, length, length, (){
      drawV(context, spacing: spacing, width: length, height: length);
    });
    context.stroke();
  });
}

void drawHalfO(CanvasRenderingContext2D context, {num spacing: 10, num width: 100, num height: 100}) {
  drawL(context, spacing: spacing, width: width/2, height: height);
  context.stroke();
  // right half
  transact(context, (){
    context..translate(width, 0)
           ..scale(-1, 1);
    drawL(context, spacing: spacing, width: width/2, height: height);
    context.stroke();
  });
}

void drawO(CanvasRenderingContext2D context, {num spacing: 10, num length: 100}) {
  drawRect(context, spacing: spacing, width: length, height: length);
  context.stroke();
}

void drawRect(CanvasRenderingContext2D context, {num spacing: 10, num width: 100, num height: 100}) {
  drawHalfO(context, spacing: spacing, width: width, height: height/2);
  context.stroke();
  // bottom
  transact(context, (){
    context..translate(0, height)
           ..scale(1, -1);
    drawHalfO(context, spacing: spacing, width: width, height: height/2);
    context.stroke();
  });
}

void drawA(CanvasRenderingContext2D context, {num spacing: 10, num length: 100}) {
  num height = length/2;
  drawRect(context, spacing: spacing, width: length, height: height);
  
  context.translate(0, height);
  drawHalfO(context, spacing: spacing, width: length, height: height);
  context.stroke();
}

void drawH(CanvasRenderingContext2D context, {num spacing: 10, num length: 100}) {
  num height = length/2;
  txRotateCenter(context, PI, length, height, (){
    drawHalfO(context, spacing: spacing, width: length, height: height);
  });
  
  context.translate(0, height);
  drawHalfO(context, spacing: spacing, width: length, height: height);
  context.stroke();
}

void drawT(CanvasRenderingContext2D context, {num spacing: 10, num length: 100}) {
  num width = length/2;
  
  context.translate(width, 0);
  transact(context, (){
    context.scale(-1, 1);
    drawL(context, spacing: spacing, width: width, height: length);
  });
  
  drawL(context, spacing: spacing, width: width, height: length);
  context.stroke();
}

void drawE(CanvasRenderingContext2D context, {num spacing: 10, num length: 100}) {
  num width = length/2;
  
  rotateCenter(context, -PI/2, length, length, (){
    drawHalfO(context, spacing: spacing, width: width, height: length);
    context.translate(width, 0);
    drawHalfO(context, spacing: spacing, width: width, height: length);
  });
  context.stroke();
}

void drawP(CanvasRenderingContext2D context, {num spacing: 10, num length: 100}) {
  num height = length/2;
  drawRect(context, spacing: spacing, width: length, height: height);
  
  context.translate(0, height);
  drawL(context, spacing: spacing, width: length, height: height);
  context.stroke();
}

void drawS(CanvasRenderingContext2D context, {num spacing: 10, num length: 100}) {
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
  context.stroke();
}

void drawB(CanvasRenderingContext2D context, {num spacing: 10, num length: 100}) {
  num height = length/2;
  drawRect(context, spacing: spacing, width: length, height: height);
  
  context.translate(0, height);
  drawRect(context, spacing: spacing, width: length, height: height);
  context.stroke();
}

void drawR(CanvasRenderingContext2D context, {num spacing: 10, num length: 100}) {
  num height = length/2;
  drawRect(context, spacing: spacing, width: length, height: height);
  
  context.translate(0, height);
  drawHalfO(context, spacing: spacing, width: length/2, height: height);
  
  context.translate(length/2, 0);
  drawL(context, spacing: spacing, width: length/2, height: height);
  
  context.stroke();
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
void rotateCenter(CanvasRenderingContext2D context, num angle, num width, num height, Function drawFn) {
  context..translate(width/2, height/2)
         ..rotate(angle)
         ..translate(-width/2, -height/2);
  drawFn();
}

// wrap rotation in a transaction for convenience
void txRotateCenter(CanvasRenderingContext2D context, num angle, num width, num height, Function drawFn) {
  transact(context, (){
    rotateCenter(context, angle, width, height, drawFn);
  });
}

Map<String, Function> letterFunctions = 
{
  "a": drawA,
  "b": drawB,
  "e": drawE,
  "h": drawH,
  "o": drawO,
  "n": drawN,
  "p": drawP,
  "r": drawR,
  "s": drawS,
  "t": drawT
};

void main() {
  // Enable this to use Shadow DOM in the browser.
  //useShadowDom = true;
  
  CanvasElement canvas = query("#ethan");
  CanvasRenderingContext2D context = canvas.getContext("2d");

  context.lineWidth = 2;
  clearContext(context);
  
  txRotateCenter(context, PI/2, 80, 80, (){
    context.translate(0, 300);
    drawSqLines(context, 80, spacing: 8);
    context.stroke();
  });
  
  transact(context, () {
    context.translate(100, 300);
    drawV(context, spacing: 8, width: 80, height: 40);
    context.stroke();
  });
  
  transact(context, () {
    context.translate(200, 300);
    drawSqLines(context, 80, spacing: 8);
    context.stroke();
  });
  
  transact(context, () {
    context.translate(300, 300);
    drawL(context, spacing: 8, width: 80, height: 80);
    context.stroke();
  });
  
  transact(context, () {
    context.translate(400, 300);
    drawRect(context, spacing: 8, width: 80, height: 40);
    context.stroke();
  });
  
  transact(context, () {
    context.translate(500, 300);
    drawRect(context, width: 80, height: 80, spacing: 8);
  });
  
  // actual letters
  List<String> name = ["ethan","psher", "bon"];
  for (num i = 0; i < name.length; i++) {
    String word = name[i];
    for (num j = 0; j < word.length; j++) {
      String letter = word.substring(j, j+1);
      window.console.log(letter);
      Function drawLetter = letterFunctions[letter];
      
      transact(context, () {
        context.translate(j*100, i*100);
        drawLetter(context, length: 80, spacing: 8);
      });
    }
  }
  
}
