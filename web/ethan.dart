library ethan;

import 'dart:html';
import 'dart:math';
import 'package:web_ui/web_ui.dart';

import 'canvas.dart';
import 'font.dart';

// THE NAME
List<String> theName = ["*ethan", "p*sher", "*bondy"];
// HASHEM

void drawName(CanvasRenderingContext2D context, FontParams params, num delta) {
  transact(context, () {
    context.lineWidth = params.lineWidth;
      
    num maxLength = params.name.fold(0, (a, b) => max(a, b.length));
    num width =  maxLength * params.translation;
    num height = params.name.length * params.translation;
    num offsetX = (context.canvas.width - width)/2;
    num offsetY = (context.canvas.height - height)/2;
    
    for (num i = 0; i < params.name.length; i++) {
      String word = params.name[i];
      
      for (num j = 0; j < word.length; j++) {
        String letter = word.substring(j, j+1);
        Function drawLetter = letterFunctions[letter];
        
        // yucky state
        params.xTranslation = offsetX + j*params.translation;
        params.yTranslation = offsetY + i*params.translation;
        
        params.updateColor(i, j);
        Map<String, num> currentColor = params.currentColors[i][j];
                        
        transact(context, () {        
          context..translate(params.xTranslation, params.yTranslation)
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
            num bgLength = params.blockSize + 2*params.lineWidth;
            context..setFillColorRgb(bgBrightness, bgBrightness, bgBrightness, 1)
                   ..fillRect(-params.lineWidth, -params.lineWidth, bgLength, bgLength);
            
            // this is dumb, I should just pass context and params as the args
            drawLetter(context, length: params.blockSize, spacing: params.innerSpacing, params: params);
          } else if (delta.floor() % 60 == 0) {
            drawLetter(context, length: params.blockSize, spacing: params.innerSpacing, params: params);
          }
          context.stroke();
        });
      }
    }
  });
  
  window.animationFrame.then((num delta){
    drawName(context, params, delta);
  });
}

void main() {
  CanvasElement canvas = query("#ethan");
  CanvasRenderingContext2D context = canvas.getContext("2d");
  context.fillStyle = "#000000";
  clearContext(context);

  // canvas.onClick.listen((event) => drawName(context, name));
  
  FontParams params = new FontParams();
  params.name = theName;
  
  window.animationFrame.then((num delta) => drawName(context, params, delta));
}
