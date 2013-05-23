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

void drawV(CanvasRenderingContext2D context, {num spacing: 10, num length: 100}) {
  for (num pos = 0; pos < length/2; pos += spacing) {
    context..moveTo(length - pos, length)
           ..lineTo(pos, 2*pos)
           ..lineTo(pos, length);
  }
}

void drawN(CanvasRenderingContext2D context, {num spacing: 10, num length: 100}) {
  drawV(context, spacing: spacing, length: length);
  context.stroke();
  // right/top of N
  transact(context, (){
    rotateCenter(context, PI, length, length, (){
      drawV(context, spacing: spacing, length: length);
    });
    context.stroke();
  });
}

void drawHalfO(CanvasRenderingContext2D context, {num spacing: 10, num length: 100}) {
  drawL(context, spacing: spacing, width: length/2, height: length/2);
  context.stroke();
  // right half
  transact(context, (){
    context.translate(length/2, 0);
    rotateCenter(context, PI/2, length/2, length/2, (){
      drawL(context, spacing: spacing, width: length/2, height: length/2);
    });
    context.stroke();
  });
}

void drawO(CanvasRenderingContext2D context, {num spacing: 10, num length: 100}) {
  drawHalfO(context, spacing: spacing, length: length);
  context.stroke();
  // bottom
  transact(context, (){
    context..translate(0, length)
           ..scale(1, -1);
    drawHalfO(context, spacing: spacing, length: length);
    context.stroke();
  });
}

void drawRectTop(CanvasRenderingContext2D context, {num spacing: 10, num width: 100, num height: 50}) {
  num smallSide = min(width, height);
  num lineWidth = (width - 2*smallSide);

  // left cap
  transact(context, (){
    drawL(context, spacing: spacing, width: smallSide, height: height);
    // line
    context.translate(smallSide, 0);
    if (lineWidth > 0) {
      drawLines(context, spacing: spacing, width: lineWidth, height: height);
    }
  });
  
  // right cap
  num rightX = 2*smallSide + max(0, lineWidth);
  transact(context, (){
    context..translate(rightX, 0)
           ..scale(-1, 1);
    drawL(context, spacing: spacing, width: smallSide, height: height);
  });
}

void drawRect(CanvasRenderingContext2D context, {num spacing: 10, num width: 100, num height: 50}) {
  drawRectTop(context, spacing: spacing, width: width, height: height/2);
  context.stroke();
  // bottom
  transact(context, (){
    context.translate(0, height/2);
    rotateCenter(context, PI, width, height/2, (){
      drawRectTop(context, spacing: spacing, width: width, height: height/2);
    });
    context.stroke();
  });
}

void drawA(CanvasRenderingContext2D context, {num spacing: 10, num length: 100}) {
  num height = length/2;
  drawRect(context, spacing: spacing, width: length, height: height);
  
  context.translate(0, height);
  drawRectTop(context, spacing: spacing, width: length, height: height);
  context.stroke();
}

void drawH(CanvasRenderingContext2D context, {num spacing: 10, num length: 100}) {
  num height = length/2;
  txRotateCenter(context, PI, length, height, (){
    drawRectTop(context, spacing: spacing, width: length, height: height);
  });
  
  context.translate(0, height);
  drawRectTop(context, spacing: spacing, width: length, height: height);
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
    drawRectTop(context, spacing: spacing, width: width/2, height: length);
    context.translate(width, 0);
    drawRectTop(context, spacing: spacing, width: width/2, height: length);
  });
  context.stroke();
}


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


void main() {
  // Enable this to use Shadow DOM in the browser.
  //useShadowDom = true;
  
  CanvasElement canvas = query("#ethan");
  CanvasRenderingContext2D context = canvas.getContext("2d");

  context.lineWidth = 2;
  clearContext(context);
  
  txRotateCenter(context, PI/2, 80, 80, (){
    drawSqLines(context, 80, spacing: 8);
    context.stroke();
  });
  
  transact(context, () {
    context.translate(100, 0);
    drawV(context, spacing: 8, length: 80);
    context.stroke();
  });
  
  transact(context, () {
    context.translate(200, 0);
    drawSqLines(context, 80, spacing: 8);
    context.stroke();
  });
  
  transact(context, () {
    context.translate(300, 0);
    drawL(context, spacing: 8, width: 80, height: 80);
    context.stroke();
  });
  
  transact(context, () {
    context.translate(400, 0);
    drawRect(context, spacing: 8, width: 80, height: 40);
    context.stroke();
  });
  
  transact(context, () {
    context.translate(500, 0);
    drawO(context, length: 80, spacing: 8);
  });
  
  // actual letters
  
  transact(context, () {
    context.translate(000, 100);
    drawE(context, length: 80, spacing: 8);
  });
  
  transact(context, () {
    context.translate(100, 100);
    drawT(context, length: 80, spacing: 8);
  });
  
  transact(context, () {
    context.translate(200, 100);
    drawH(context, length: 80, spacing: 8);
  });
  
  transact(context, () {
    context.translate(300, 100);
    drawA(context, length: 80, spacing: 8);
  });
  
  transact(context, () {
    context.translate(400, 100);
    drawN(context, spacing: 8, length: 80);
  });
}
