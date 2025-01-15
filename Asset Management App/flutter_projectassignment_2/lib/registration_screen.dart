import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Controllers for text fields to capture user input
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final icController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return Scaffold(
      backgroundColor: Color(0xFFA6E3E9), // Set background color for the scaffold
      appBar: AppBar(
        title: const Text('Create an Account'), // Title for the AppBar
        backgroundColor: Color(0xFF00ADB5), // AppBar color
      ),
      
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0), // Padding for inner content
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center the column contents
            children: [
              // Text field for user name input
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 10), // Add spacing between fields
              
              // Text field for email input
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 10),
              
              // Text field for phone number input
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              const SizedBox(height: 10),
              
              // Text field for identity card input
              TextField(
                controller: icController,
                decoration: const InputDecoration(labelText: 'Identity Card (IC)'),
              ),
              const SizedBox(height: 10),
              
              // Text field for password input with obscured text
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 10),
              
              // Text field for confirm password input with obscured text
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Confirm Password'),
              ),
              const SizedBox(height: 20),
              
              // Button to handle registration process
              ElevatedButton(
                onPressed: () async {
                  // Validation: Check if any field is empty
                  if (nameController.text.isEmpty ||
                      emailController.text.isEmpty ||
                      phoneController.text.isEmpty ||
                      icController.text.isEmpty ||
                      passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill in all fields')),
                    );
                    return;
                  }

                  // Validation: Check if passwords match
                  if (passwordController.text != confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Passwords do not match')),
                    );
                    return;
                  }

                  // Show loading dialog while processing
                  showDialog(
                    context: context,
                    barrierDismissible: false, // Prevent dismissing by tapping outside
                    builder: (BuildContext context) {
                      return const Center(child: CircularProgressIndicator());
                    },
                  );

                  try {
                    // Register user with Firebase Authentication
                    final userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );

                    // Save user data to Firestore
                    await FirebaseFirestore.instance
                        .collection('users') // Create "users" collection if not exists
                        .doc(userCredential.user!.uid) // Use user's UID as document ID
                        .set({
                      'userId': userCredential.user!.uid, // Save user's UID
                      'name': nameController.text, // Save name
                      'email': emailController.text, // Save email
                      'phone': phoneController.text, // Save phone number
                      'ic': icController.text, // Save identity card number
                      'address': '', // Placeholder for address
                      'createdAt': FieldValue.serverTimestamp(), // Timestamp when account created
                    });

                    Navigator.pop(context); // Close loading dialog

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Registration successful! Please login.'),
                        backgroundColor: Colors.green, // Success message background color
                      ),
                    );

                    // Navigate to login screen after a delay
                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login', // Route to login screen
                        (Route<dynamic> route) => false, // Remove all previous routes
                      );
                    });
                  } catch (e) {
                    // Close loading dialog on error
                    Navigator.pop(context);
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Registration failed: ${e.toString()}'),
                        backgroundColor: Colors.red, // Error message background color
                      ),
                    );
                  }
                },
                child: const Text('Register'), // Button text
              ),
            ],
          ),
        ),
      ),
    );
  }
}
