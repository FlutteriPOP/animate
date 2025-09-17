import 'package:flutter/material.dart';

class AnimationPadding extends StatefulWidget {
  const AnimationPadding({super.key});

  @override
  State<AnimationPadding> createState() => _AnimationPaddingState();
}

class _AnimationPaddingState extends State<AnimationPadding> {
  double paddign = 10.0;

  void togglePadding() {
    setState(() {
      paddign = paddign == 10.0 ? 50.0 : 10.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          AnimatedPadding(
            padding: EdgeInsets.all(paddign),
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.blue,
                  child: Center(child: Text('Item $index')),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          AnimatedPadding(
            padding: EdgeInsets.all(paddign),
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            child: Container(
              width: 200,
              height: 200,
              color: Colors.red,
              child: const Center(
                child: Text(
                  'Animated Padding',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: togglePadding,
            child: const Text('Toggle Padding'),
          ),
        ],
      ),
    );
  }
}
