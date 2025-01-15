import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'asset_location.dart';
import 'faq_page.dart';
import 'dashboard_screen.dart';
import 'helpdesk_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // User profile fields
  String name = 'Loading...';
  String email = 'Loading...';
  String phone = 'Loading...';
  String address = 'Loading...';
  String dateJoined = 'Loading...';
  String lastLogin = 'Loading...';
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userData = await _firestore.collection('users').doc(user.uid).get();
        if (userData.exists) {
          setState(() {
            name = userData.data()?['name'] ?? 'No Name';
            email = userData.data()?['email'] ?? 'No Email';
            phone = userData.data()?['phone'] ?? 'No Phone';
            address = userData.data()?['address'] ?? 'No Address';
            profileImageUrl = userData.data()?['profileImageUrl'];
            dateJoined = user.metadata.creationTime?.toString().split(' ')[0] ?? 'Unknown';
            lastLogin = user.metadata.lastSignInTime?.toString().split(' ')[0] ?? 'Unknown';
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User profile not found in Firestore.')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading user profile: ${e.toString()}')),
      );
    }
  }

  Future<void> _uploadProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      try {
        final user = _auth.currentUser;
        if (user != null) {
          String fileName = 'assets/profile_${user.uid}.jpg';
          final ref = _storage.ref().child(fileName);

          UploadTask uploadTask = ref.putFile(imageFile);
          TaskSnapshot snapshot = await uploadTask;
          String downloadUrl = await snapshot.ref.getDownloadURL();

          await _firestore.collection('users').doc(user.uid).update({
            'profileImageUrl': downloadUrl,
          });

          setState(() {
            profileImageUrl = downloadUrl;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile picture updated successfully!')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      }
    }
  }

  void _showImageOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Profile Picture'),
        content: const Text('Do you want to update your profile picture?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _uploadProfileImage();
            },
            child: const Text('Choose Image'),
          ),
        ],
      ),
    );
  }

  void _editProfile() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController nameController = TextEditingController(text: name);
        TextEditingController emailController = TextEditingController(text: email);
        TextEditingController phoneController = TextEditingController(text: phone);
        TextEditingController addressController = TextEditingController(text: address);

        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final user = _auth.currentUser;
                if (user != null) {
                  await _firestore.collection('users').doc(user.uid).update({
                    'name': nameController.text,
                    'email': emailController.text,
                    'phone': phoneController.text,
                    'address': addressController.text,
                  });

                  setState(() {
                    name = nameController.text;
                    email = emailController.text;
                    phone = phoneController.text;
                    address = addressController.text;
                  });

                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222831),
      appBar: AppBar(
        backgroundColor: Color(0xFF00ADB5),
        centerTitle: true,
        title: const Text('Profile'),
      ),
      drawer: const AppDrawer(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 20,
                margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color:Color(0xFFCBF1F5),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Transform.translate(
                          offset: const Offset(0, -100),
                          child: GestureDetector(
                            onTap: _showImageOptions,
                            child: CircleAvatar(
                              radius: 100,
                              backgroundImage: profileImageUrl != null
                                  ? NetworkImage(profileImageUrl!)
                                  : null,
                              backgroundColor: Colors.blue,
                              child: profileImageUrl == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 200,
                                      color:  Colors.green,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        name,
                        style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Table(
                        border: TableBorder.all(color: Colors.black, width: 1),
                        columnWidths: const {0: IntrinsicColumnWidth(), 1: FlexColumnWidth()},
                        children: [
                          _buildTableRow('Email:', email),
                          _buildTableRow('Phone:', phone),
                          _buildTableRow('Address:', address),
                          _buildTableRow('Date Joined:', dateJoined),
                          _buildTableRow('Last Login:', lastLogin),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _editProfile,
                    child: const Text('Edit', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _logout,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Log Out', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value, style: const TextStyle(fontSize: 18)),
        ),
      ],
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
            decoration: BoxDecoration(color: Color(0xFF00ADB5)),
            child: Text(
              'Asset Management',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Homepage'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  DashboardScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Helpdesk'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpDeskScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Asset Map'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  AssetLocation()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.announcement_rounded),
            title: const Text('FAQ!'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FAQPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('LogOut'),
            onTap: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
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
