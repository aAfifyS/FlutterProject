import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'asset_location.dart';
import 'faq_page.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'helpdesk_screen.dart';

class DashboardScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DashboardScreen({super.key});

  Future<int> _getTotalAssets() async {
    final user = _auth.currentUser;
    if (user != null) {
      final QuerySnapshot result = await _firestore
          .collection('assets')
          .where('userId', isEqualTo: user.uid)
          .get();
      return result.size;
    }
    return 0;
  }

  Stream<QuerySnapshot> _getRecentActivity() {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('assets')
          .where('userId', isEqualTo: user.uid)
          .where('status', isEqualTo: 'Maintenance')
          .orderBy('createdAt', descending: true)
          .limit(4)
          .snapshots();
    }
    return const Stream.empty();
  }

  Stream<String> _trackAssetChanges() {
  final user = _auth.currentUser;
  if (user != null) {
    final userName = user.displayName ?? 'User'; // Gunakan nama pengguna jika ada
    return _firestore
        .collection('assets')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.modified) {
          final data = change.doc.data() as Map<String, dynamic>;
          final assetName = data['assetName'] ?? 'Unnamed Asset';
          return '$userName has updated $assetName';
        }
      }
      return '';
    });
  }
  return Stream.value('');
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222831),
      appBar: AppBar(
        title: const Text('Asset Manager'),
        backgroundColor: const Color(0xFF00ADB5),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/addasset');
            },
            child: const Text('Add'),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/viewasset');
            },
            child: const Text('View'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: FutureBuilder<int>(
                          future: _getTotalAssets(),
                          builder: (context, snapshot) {
                            return Container(
                              height: 150,
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFF5C8374),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Total Asset',
                                    style: TextStyle(
                                      fontSize: 30,color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'You have ${snapshot.data ?? 0} assets registered',
                                    style: const TextStyle(fontSize: 20,color: Colors.white),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: _getRecentActivity(),
                          builder: (context, snapshot) {
                            return Container(
                              height: 150,
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFF9EC889),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Recent Activity',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty)
                                    ...snapshot.data!.docs.map((doc) {
                                      final data = doc.data() as Map<String, dynamic>;
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          'Asset ${data['assetName']} is under maintenance',
                                          style: const TextStyle(fontSize: 20,color: Colors.white),
                                        ),
                                      );
                                    }),
                                  StreamBuilder<String>(
                                    stream: _trackAssetChanges(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                                        return Text(
                                          snapshot.data!,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: const Color(0xFFCBF1F5),
            padding: const EdgeInsets.all(16.0),
            child: const Center(
              child: Text(
                '© 2025 Asset Management App by Afify',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
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
