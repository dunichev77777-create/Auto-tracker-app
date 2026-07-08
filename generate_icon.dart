import 'dart:io';
import 'package:image/image.dart';

void main() {
  // Create a 1024x1024 icon
  final image = Image(width: 1024, height: 1024);
  
  // Fill with blue background
  fill(image, color: ColorRgb8(33, 150, 243)); // Blue #2196F3
  
  // Add a white car-like shape (simple rectangle)
  final carColor = ColorRgb8(255, 255, 255);
  
  // Car body
  drawRect(image, x1: 200, y1: 400, x2: 824, y2: 600, color: carColor);
  
  // Car top
  drawRect(image, x1: 300, y1: 300, x2: 724, y2: 400, color: carColor);
  
  // Wheels
  fillCircle(image, x: 350, y: 650, radius: 80, color: ColorRgb8(50, 50, 50));
  fillCircle(image, x: 674, y: 650, radius: 80, color: ColorRgb8(50, 50, 50));
  
  // Save the image
  final file = File('assets/icon.png');
  file.parent.createSync(recursive: true);
  final png = encodePng(image);
  file.writeAsBytesSync(png);
  
  print('Icon created at assets/icon.png');
}
