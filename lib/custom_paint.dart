import 'package:expressive_loading_indicator/expressive_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:material_new_shapes/material_new_shapes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 150, // Desired width
            height: 150, // Desired height
            child: ExpressiveLoadingIndicator(
              color: Colors.purple,
              polygons: [
                MaterialShapes.softBurst,
                MaterialShapes.pentagon,
                MaterialShapes.pill,
              ],
              semanticsLabel: 'Loading',
              semanticsValue: 'In progress',
            ),
          ),
        ),
      ),
    );
  }
}





