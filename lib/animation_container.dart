import 'package:flutter/material.dart';

class AnimationContainer extends StatefulWidget {
  const AnimationContainer({super.key});

  @override
  State<AnimationContainer> createState() => _AnimationContainerState();
}

class _AnimationContainerState extends State<AnimationContainer> {
  // State variables
  double height = 100;
  double width = 100;
  Color color = Colors.blue;
  double borderRadius = 0;
  double rotation = 0;
  double opacity = 1.0;
  bool showShadow = false;
  bool showImage = false;
  bool showGradient = false;

  // Image URLs
  final String img1 =
      'https://images.unsplash.com/photo-1501854140801-50d01698950b?w=400';
  final String img2 =
      'https://images.unsplash.com/photo-1502082553048-f009c37129b9?w=400';

  void reset() {
    setState(() {
      height = 100;
      width = 100;
      color = Colors.blue;
      borderRadius = 0;
      rotation = 0;
      opacity = 1.0;
      showShadow = false;
      showImage = false;
      showGradient = false;
    });
  }

  void changeSize() {
    setState(() {
      height = height == 100 ? 200 : 100;
      width = width == 100 ? 200 : 100;
    });
  }

  void changeColor() {
    setState(() {
      color = color == Colors.blue
          ? Colors.red
          : color == Colors.red
          ? Colors.green
          : Colors.blue;
    });
  }

  void toggleBorderRadius() {
    setState(() {
      borderRadius = borderRadius == 0 ? 50 : 0;
    });
  }

  void rotateContainer() {
    setState(() {
      rotation = rotation == 0 ? 0.9 : 0;
    });
  }

  void toggleOpacity() {
    setState(() {
      opacity = opacity == 1.0 ? 0.5 : 1.0;
    });
  }

  void toggleShadow() {
    setState(() {
      showShadow = !showShadow;
    });
  }

  void toggleImage() {
    setState(() {
      showImage = !showImage;
    });
  }

  void toggleGradient() {
    setState(() {
      showGradient = !showGradient;
    });
  }

  void applyAllEffects() {
    setState(() {
      height = 250;
      width = 250;
      color = Colors.purple;
      borderRadius = 25;
      rotation = 0.25;
      opacity = 0.8;
      showShadow = true;
      showImage = true;
      showGradient = true;
    });
  }

  Decoration _buildDecoration() {
    if (showGradient) {
      return BoxDecoration(
        gradient: LinearGradient(
          colors: [color, Colors.deepPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha:  0.4),
                  blurRadius: 15,
                  spreadRadius: 3,
                  offset: const Offset(4, 4),
                ),
              ]
            : null,
        image: showImage
            ? DecorationImage(
                image: NetworkImage(showGradient ? img1 : img2),
                fit: BoxFit.cover,
                opacity: opacity,
              )
            : null,
      );
    }

    return BoxDecoration(
      color: color.withValues(alpha:opacity),
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: showShadow
          ? [
              BoxShadow(
                color: Colors.black.withValues(alpha:0.4),
                blurRadius: 15,
                spreadRadius: 3,
                offset: const Offset(4, 4),
              ),
            ]
          : null,
      image: showImage
          ? DecorationImage(
              image: NetworkImage(img2),
              fit: BoxFit.cover,
              opacity: opacity,
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated Container Playground'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: reset,
            tooltip: 'Reset All',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Animated Container
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOutQuint,
              height: height,
              width: width,
              decoration: _buildDecoration(),
              transform: Matrix4.rotationZ(rotation),
              child: showImage
                  ? null
                  : Center(
                      child: Text(
                        'Hello!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: height * 0.1,
                          fontWeight: FontWeight.bold,
                          shadows: showShadow
                              ? [
                                  Shadow(
                                    blurRadius: 10,
                                    color: Colors.black.withValues(alpha:0.8),
                                    offset: const Offset(2, 2),
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    ),
            ),

            const SizedBox(height: 30),

            // Control Buttons Grid
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                _buildActionButton(
                  icon: Icons.aspect_ratio,
                  label: 'Size',
                  onPressed: changeSize,
                  color: Colors.blue,
                ),
                _buildActionButton(
                  icon: Icons.color_lens,
                  label: 'Color',
                  onPressed: changeColor,
                  color: Colors.red,
                ),
                _buildActionButton(
                  icon: Icons.crop_square,
                  label: 'Corners',
                  onPressed: toggleBorderRadius,
                  color: Colors.green,
                ),
                _buildActionButton(
                  icon: Icons.rotate_right,
                  label: 'Rotate',
                  onPressed: rotateContainer,
                  color: Colors.orange,
                ),
                _buildActionButton(
                  icon: Icons.opacity,
                  label: 'Opacity',
                  onPressed: toggleOpacity,
                  color: Colors.purple,
                ),
                _buildActionButton(
                  icon: Icons.light_mode,
                  label: 'Shadow',
                  onPressed: toggleShadow,
                  color: Colors.brown,
                ),
                _buildActionButton(
                  icon: Icons.image,
                  label: 'Image',
                  onPressed: toggleImage,
                  color: Colors.teal,
                ),
                _buildActionButton(
                  icon: Icons.gradient,
                  label: 'Gradient',
                  onPressed: toggleGradient,
                  color: Colors.pink,
                ),
                _buildActionButton(
                  icon: Icons.auto_awesome,
                  label: 'All Effects',
                  onPressed: applyAllEffects,
                  color: Colors.deepPurple,
                ),
                _buildActionButton(
                  icon: Icons.refresh,
                  label: 'Reset',
                  onPressed: reset,
                  color: Colors.grey,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Status Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Properties:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text('Size: ${width.toInt()}x${height.toInt()}'),
                  Text('Color: ${color.toString().split('.').last}'),
                  Text('Border Radius: ${borderRadius.toInt()}'),
                  Text('Rotation: ${(rotation * 180).toInt()}°'),
                  Text('Opacity: ${opacity.toStringAsFixed(1)}'),
                  Text('Shadow: ${showShadow ? "On" : "Off"}'),
                  Text('Image: ${showImage ? "On" : "Off"}'),
                  Text('Gradient: ${showGradient ? "On" : "Off"}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
