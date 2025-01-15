import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  // Animation controller and animations
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller with a duration of 2 seconds
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Define scale animation with an elastic out curve
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    // Define fade animation transitioning from 0 to 1 opacity
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    // Dispose of the animation controller to free resources
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calorie Intake Calculator', // Title of the app bar
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 78, 2, 86), // App bar color
      ),
      body: Container(
        color: const Color(0xFF910A67), // Background color of the page
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center the content
            children: [
              // ScaleTransition for the dumbbell image
              ScaleTransition(
                scale: _scaleAnimation, // Apply scale animation
                child: Image.asset(
                  'lib/image/dumbell.png', // Path to the image asset
                  height: 200, // Height of the image
                ),
              ),
              const SizedBox(height: 20), // Space between image and text
              // FadeTransition for the welcome text
              FadeTransition(
                opacity: _fadeAnimation, // Apply fade animation
                child: const Text(
                  'Welcome to the Calorie Intake Calculator!', // Welcome message
                  style: TextStyle(
                    fontSize: 25, // Font size
                    color: Color.fromARGB(255, 255, 251, 251), // Text color
                  ),
                  textAlign: TextAlign.center, // Center align text
                ),
              ),
              const SizedBox(height: 20), // Space between text and button
              // Button to navigate to the calculator page
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/calculator'); // Navigate to calculator page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Button background color
                  foregroundColor: Colors.black, // Button foreground color
                ),
                child: const Text(
                  'Start Calculation', // Button label
                  style: TextStyle(color: Colors.white), // Text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
