import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'asset_location.dart';
import 'dashboard_screen.dart';
import 'helpdesk_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: const Color(0xFF00ADB5),
        title: const Text('FAQ - Asset Management App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: const [
            Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ExpansionTile(
                title: Text('What is Asset Management App?'),
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'The Asset Management App is designed to help track, manage, and organize physical or digital assets within an organization or personal collection.',
                    ),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ExpansionTile(
                title: Text('How does Asset Management App function?'),
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'The app allows users to register, categorize, and maintain assets. It also provides features like asset search, tracking, and reporting for efficient management.',
                    ),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ExpansionTile(
                title: Text('Why is Asset Management App needed?'),
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'An asset management app helps users track the lifecycle of assets, improve accountability, prevent loss, and streamline the allocation of resources for better operational efficiency.',
                    ),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ExpansionTile(
                title: Text('When do I need an Asset Management App?'),
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'If you have a large inventory of assets, whether physical or digital, and need a way to organize, track, and manage them efficiently, an asset management app is essential.',
                    ),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ExpansionTile(
                title: Text('Where do I apply the Asset Management App?'),
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'The app can be applied in various sectors such as businesses, organizations, educational institutions, or even personal use for managing assets like electronics, equipment, or vehicles.',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF00ADB5),
            ),
            child: Text(
              'Asset Management',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Homepage'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Helpdesk'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpDeskScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Asset Map'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AssetLocation()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.announcement_rounded),
            title: const Text('FAQ!'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FAQPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('LogOut'),
            onTap: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error logging out: $e')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
