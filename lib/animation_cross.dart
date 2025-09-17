import 'package:flutter/material.dart';

import 'commons.dart';

class AnimationCross extends StatefulWidget {
  const AnimationCross({super.key});

  @override
  State<AnimationCross> createState() => _AnimationCrossState();
}

class _AnimationCrossState extends State<AnimationCross> {
  // Random images from Unsplash

  CrossFadeState _currentState = CrossFadeState.showFirst;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    // Start automatic image switching
    _startAnimation();
  }

  void _startAnimation() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _currentState = _currentState == CrossFadeState.showFirst
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst;

          // Cycle through different images
          _currentImageIndex = (_currentImageIndex + 1) % 4;
        });
        _startAnimation(); // Continue the animation loop
      }
    });
  }

  Widget _getCurrentFirstChild() {
    switch (_currentImageIndex) {
      case 0:
        return _buildImageContainer(img1);
      case 1:
        return _buildImageContainer(img2);
      case 2:
        return _buildImageContainer(img3);
      case 3:
        return _buildImageContainer(img4);
      default:
        return _buildImageContainer(img1);
    }
  }

  Widget _getCurrentSecondChild() {
    switch ((_currentImageIndex + 1) % 4) {
      case 0:
        return _buildImageContainer(img1);
      case 1:
        return _buildImageContainer(img2);
      case 2:
        return _buildImageContainer(img3);
      case 3:
        return _buildImageContainer(img4);
      default:
        return _buildImageContainer(img1);
    }
  }

  Widget _buildImageContainer(String imageUrl) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: const Icon(Icons.error, color: Colors.red, size: 50),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cross Fade Animation'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedCrossFade(
              firstChild: _getCurrentFirstChild(),
              secondChild: _getCurrentSecondChild(),
              crossFadeState: _currentState,
              duration: const Duration(seconds: 2),
              firstCurve: Curves.easeInOut,
              secondCurve: Curves.easeInOut,
              sizeCurve: Curves.easeInOut,
            ),
            const SizedBox(height: 20),
            Text(
              'Image ${_currentImageIndex + 1}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentState = _currentState == CrossFadeState.showFirst
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst;
                  _currentImageIndex = (_currentImageIndex + 1) % 4;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('Next Image'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Cancel any ongoing animations
    super.dispose();
  }
}
