import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key}); // Constructor for SplashScreen

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  // Declare animation controller and animations
  late AnimationController _controller;
  late Animation<double> _fadeAnimation; // Animation for fading effect
  late Animation<Offset> _slideAnimation; // Animation for sliding effect

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController with 3-second duration
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this, // Required for animation controller
    );

    // Define fade-in animation with ease-in curve
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    // Define slide-in animation for button
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 2), // Start position (below screen)
      end: Offset.zero, // End position (original position)
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut, // Ease-out curve for smooth effect
    ));

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    // Dispose the animation controller to free resources
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222831), // Background color for splash screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center the content horizontally
          children: [
            // Icon with fade-in effect
            FadeTransition(
              opacity: _fadeAnimation, // Apply fade animation
              child: const Icon(
                Icons.lock, // Icon for the splash screen
                size: 100, // Icon size
                color: Color(0xFF00ADB5), // Icon color
              ),
            ),
            const SizedBox(height: 20), // Space between icon and text
            // Title text with fade-in effect
            FadeTransition(
              opacity: _fadeAnimation, // Apply fade animation
              child: const Text(
                'Asset Manager', // App title
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10), // Space between title and subtitle
            // Subtitle text with fade-in effect
            FadeTransition(
              opacity: _fadeAnimation, // Apply fade animation
              child: const Text(
                'Manage assets with ease and precision', // Subtitle text
                textAlign: TextAlign.center, // Center align the text
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30), // Space between subtitle and button
            // Button with slide-in animation
            SlideTransition(
              position: _slideAnimation, // Apply slide animation
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to login page and remove splash screen from navigation stack
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login', // Navigate to login page
                    (Route<dynamic> route) => false, // Clear navigation stack
                  );
                },
                child: const Text('Get Started'), // Button text
              ),
            ),
          ],
        ),
      ),
    );
  }
}
