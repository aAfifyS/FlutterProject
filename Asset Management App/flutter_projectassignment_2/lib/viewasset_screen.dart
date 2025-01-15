import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'asset_location.dart';
import 'dashboard_screen.dart';
import 'faq_page.dart';
import 'helpdesk_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';

class ViewAssetScreen extends StatefulWidget {
  const ViewAssetScreen({super.key});

  @override
  _ViewAssetScreenState createState() => _ViewAssetScreenState();
}

class _ViewAssetScreenState extends State<ViewAssetScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String searchQuery = '';

  Stream<QuerySnapshot> _getAssets() {
    final user = _auth.currentUser;
    if (user != null) {
      if (searchQuery.isEmpty) {
        return _firestore
            .collection('assets')
            .where('userId', isEqualTo: user.uid)
            .snapshots();
      }
      return _firestore
          .collection('assets')
          .where('userId', isEqualTo: user.uid)
          .where('assetName', isGreaterThanOrEqualTo: searchQuery)
          .where('assetName', isLessThan: '${searchQuery}z')
          .snapshots();
    }
    return const Stream.empty();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222831),
      appBar: AppBar(title: const Text('Asset Manager'), backgroundColor: const Color(0xFF00ADB5)),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Search assets...',
                border: OutlineInputBorder(),
                filled: true, // Enable background color
                fillColor: Color(0xFFE0F7FA), // Set the background color (light cyan in this case)
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getAssets(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No assets found'));
                }
                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>?;
                    return AssetCard(
                      assetId: doc.id,
                      assetName: data?['assetName'] ?? 'Unknown',
                      assetType: data?['assetType'] ?? 'Unknown',
                      imageUrl: data?['imageUrl'], // Tambahkan URL gambar
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AssetCard extends StatelessWidget {
  final String assetId;
  final String assetName;
  final String assetType;
  final String? imageUrl; // Tambahkan parameter untuk gambar

  const AssetCard({
    super.key,
    required this.assetId,
    required this.assetName,
    required this.assetType,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to asset details screen on card tap
        Navigator.pushNamed(
          context,
          '/details',
          arguments: assetId,
        );
      },
      child: Card(
  margin: const EdgeInsets.all(8),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15), // Tambahkan lengkungan pada tepi
  ),
  elevation: 5, // Tambahkan bayangan untuk lebih estetik
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center, // Selaraskan elemen secara menegak di tengah
      children: [
        // Avatar Gambar
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey[300], // Latar belakang warna lebih lembut
          backgroundImage: imageUrl != null
              ? NetworkImage(imageUrl!) // Paparkan gambar jika ada URL
              : null,
          child: imageUrl == null
              ? const Icon(Icons.image, size: 40, color: Colors.grey) // Paparkan ikon jika tiada gambar
              : null,
        ),
        const SizedBox(width: 16), // Jarak antara avatar dan teks

        // Kolum Teks
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Selaraskan teks di sebelah kiri
            mainAxisAlignment: MainAxisAlignment.center, // Pusatkan secara menegak
            children: [
              Text(
                assetName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 10), // Tambahkan jarak antara nama dan jenis
              Text(
                assetType,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ],
    ),
  ),
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
