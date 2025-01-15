//code yang dah backup 

import 'package:flutter/material.dart';
import 'home_page.dart';
import 'calorie_calculator_page.dart';
import 'calorie_result_page.dart';

// Entry point of the Flutter application
void main() {
  runApp(const CalorieCalculatorApp()); // Runs the CalorieCalculatorApp widget
}

// Root widget of the application
class CalorieCalculatorApp extends StatelessWidget {
  const CalorieCalculatorApp({super.key}); // Constructor for the root widget

  @override
  Widget build(BuildContext context) {
    // Builds the MaterialApp widget, which serves as the root of the app's navigation and theming
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hides the debug banner in the app
      title: 'Calorie Intake Calculator', // Sets the title of the application
      theme: ThemeData(primarySwatch: Colors.blue), // Applies a blue theme to the app
      initialRoute: '/', // Sets the default route to the HomePage
      routes: {
        // Defines the named routes for navigation within the app
        '/': (context) => const HomePage(), // Maps '/' to HomePage widget
        '/calculator': (context) => const CalorieCalculatorPage(), // Maps '/calculator' to CalorieCalculatorPage widget
        '/result': (context) => const CalorieResultPage(), // Maps '/result' to CalorieResultPage widget
      },
    );
  }
}
