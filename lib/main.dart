import 'package:flutter/material.dart';

void main() {
  runApp(const AnimationPlayground());
}

class AnimationPlayground extends StatelessWidget {
  const AnimationPlayground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Animation Playground',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AnimationHome(),
    );
  }
}

class AnimationHome extends StatefulWidget {
  const AnimationHome({Key? key}) : super(key: key);

  @override
  _AnimationHomeState createState() => _AnimationHomeState();
}

class _AnimationHomeState extends State<AnimationHome>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  double _opacity = 0.0;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller for scaling animation
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 1.5).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Animation Playground',
          style: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Animated Container
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  width: _isExpanded ? 200 : 100,
                  height: _isExpanded ? 200 : 100,
                  color: _isExpanded ? Colors.red : Colors.blue,
                  child: const Center(
                    child: Text(
                      'Tap Me!',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Fade-In Animation
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _opacity = _opacity == 0.0 ? 1.0 : 0.0;
                });
              },
              child: const Text('Fade In / Out'),
            ),
            AnimatedOpacity(
              duration: const Duration(seconds: 2),
              opacity: _opacity,
              child: const Icon(Icons.star, color: Colors.orange, size: 50),
            ),
            const SizedBox(height: 40),
            // Scale Animation
            ElevatedButton(
              onPressed: () {
                if (_controller.status == AnimationStatus.completed) {
                  _controller.reverse();
                } else {
                  _controller.forward();
                }
              },
              child: const Text('Scale Animation'),
            ),
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: child,
                );
              },
              child: const Icon(Icons.favorite, color: Colors.pink, size: 100),
            ),
          ],
        ),
      ),
    );
  }
}
