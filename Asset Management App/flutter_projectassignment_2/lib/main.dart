// Import necessary Flutter and Firebase packages
import 'package:flutter/material.dart';
import '../asset_location.dart'; // Asset location screen
import '../details_screen.dart'; // Details screen for assets
import 'splash_screen.dart'; // Splash screen
import 'login_screen.dart'; // Login screen
import 'registration_screen.dart'; // Registration screen
import 'dashboard_screen.dart'; // Dashboard screen
import 'profile_screen.dart'; // Profile screen
import 'addasset_screen.dart'; // Add Asset screen
import 'viewasset_screen.dart'; // View Asset screen
import 'package:firebase_core/firebase_core.dart'; // Firebase initialization

void main() async {
  // Ensure Flutter widgets are initialized before Firebase
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase before running the app
  await Firebase.initializeApp();
  runApp(const MyApp()); // Launch the app
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor for the app

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false, // Disable debug banner

      // Title of the app
      title: 'Asset Manager',
      // Theme for the app (primary color is blue)
      theme: ThemeData(primarySwatch: Colors.blue),
      
      // Initial route when the app is launched
      initialRoute: '/',
      
      // Define the routes for navigation within the app
      routes: {
        '/': (context) => const SplashScreen(), // Splash screen
        '/login': (context) => const LoginScreen(), // Login screen
        '/register': (context) => const RegistrationScreen(), // Registration screen
        '/dashboard': (context) =>  DashboardScreen(), // Dashboard screen
        '/profile': (context) => const ProfileScreen(), // Profile screen
        '/addasset': (context) =>  const AddAssetScreen(), // Add Asset screen
        '/viewasset': (context) =>   const ViewAssetScreen(), // View Asset screen
        '/details': (context) { // Details screen for assets
          // Retrieve the assetId from navigation arguments
          final assetId = ModalRoute.of(context)!.settings.arguments as String;
          return AssetDetails(assetId: assetId); // Pass assetId to the details screen
        },
        '/map': (context) =>   AssetLocation(), // Asset map screen
      },
    );
  }
}