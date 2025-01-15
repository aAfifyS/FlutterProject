import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key}); // Constructor for the LoginScreen

  @override
  Widget build(BuildContext context) {
    // Controllers for email and password input fields
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Container(
        // Apply linear gradient as background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, // Gradient starts from top left
            end: Alignment.bottomRight, // Gradient ends at bottom right
            colors: [
              Color(0xFFA6E3E9), // Light blue color
              Color(0xFF00ADB5), // Blue-green color
              Color(0xFF393E46), // Dark gray color
              Color(0xFF222831), // Very dark gray color
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding around the content
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
            children: [
              const Text(
                "Asset Management", // Title of the app
                style: TextStyle(
                  fontSize: 40, // Font size for title
                  color: Color(0xEEEEEEEE), // Text color
                  fontWeight: FontWeight.bold, // Bold font weight
                ),
              ),
              const SizedBox(height: 60), // Space between title and email input
              // TextField for email input
              TextField(
                controller: emailController, // Controller for email input
                decoration: const InputDecoration(
                  labelText: 'Email', // Label for email field
                  hintText: 'Please enter a valid email address', // Placeholder text
                ),
              ),
              const SizedBox(height: 20), // Space between email and password inputs
              // TextField for password input
              TextField(
                controller: passwordController, // Controller for password input
                obscureText: true, // Hide password input
                decoration: const InputDecoration(
                  labelText: 'Password', // Label for password field
                  hintText: 'Password must be at least 8 characters', // Placeholder text
                ),
              ),
              const SizedBox(height: 20), // Space before login button
              // ElevatedButton for login action
              ElevatedButton(
                onPressed: () async {
                  try {
                    final email = emailController.text; // Get email input
                    final password = passwordController.text; // Get password input

                    // Sign in with Firebase authentication
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email, password: password);

                    // Navigate to dashboard upon successful login
                    Navigator.pushNamed(context, '/dashboard');
                  } catch (e) {
                    // Show error message if login fails
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Login failed: $e')),
                    );
                  }
                },
                child: const Text('Login'), // Label for login button
              ),
              const SizedBox(height: 16), // Space before register button
              // ElevatedButton for navigating to registration screen
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register'); // Navigate to registration screen
                },
                child: const Text('Register'), // Label for register button
              ),
              const SizedBox(height: 16), // Space before forgot password button
              // TextButton for forgot password functionality
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context, // Show reset password dialog
                    builder: (BuildContext context) {
                      final emailController = TextEditingController(); // Controller for reset email input
                      return AlertDialog(
                        title: const Text('Reset Password'), // Dialog title
                        content: TextField(
                          controller: emailController, // Email input for reset
                          decoration: const InputDecoration(
                            labelText: 'Email', // Label for reset email field
                            hintText: 'Enter your registered email', // Placeholder text
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: const Text('Cancel'), // Cancel button label
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog first
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Reset Password link has been sent to your registered email :)'), // Confirmation message
                                ),
                              );
                            },
                            child: const Text('Submit'), // Submit button label
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Forgot Password?'), // Label for forgot password button
              ),
            ],
          ),
        ),
      ),
    );
  }
}
