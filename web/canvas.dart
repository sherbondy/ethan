library canvas;

import 'dart:html';
import 'dart:math';

// general canvas helper functins

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