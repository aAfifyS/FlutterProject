import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AssetDetails extends StatefulWidget {
  final String assetId;
  const AssetDetails({super.key, required this.assetId});

  @override
  State<AssetDetails> createState() => _AssetDetailsState();
}

class _AssetDetailsState extends State<AssetDetails> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  bool _isDetailsHidden = false;

//image punya tempat 1
Future<void> _showImageChangeAlert(String currentImageUrl) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Image'),
        content: const Text('Do you want to change the image?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _pickAndUploadImage();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

   Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      await _uploadImageToFirebase(imageFile);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected')),
      );
    }
  }

  Future<void> _uploadImageToFirebase(File imageFile) async {
    try {
      String fileName = 'assets/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageRef = _storage
          .refFromURL('gs://assetmanagement-35d13.firebasestorage.app')
          .child(fileName);

      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();

      await _firestore.collection('assets').doc(widget.assetId).update({
        'imageUrl': downloadUrl,
      });

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
    }
  }


  void _showShareSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.3,
        minChildSize: 0.2,
        maxChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                'Share via: ',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildShareButton(Icons.email, 'Email'),
                  _buildShareButton(Icons.telegram, 'Telegram'),
                  _buildShareButton(Icons.download, 'Generate PDF'),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void _editAsset(Map<String, dynamic> assetData) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController nameController =
            TextEditingController(text: assetData['assetName']);
        TextEditingController typeController =
            TextEditingController(text: assetData['assetType']);
        TextEditingController modelController =
            TextEditingController(text: assetData['model']);
        TextEditingController serialController =
            TextEditingController(text: assetData['serialNumber']);
        TextEditingController statusController =
            TextEditingController(text: assetData['status']);
        TextEditingController locationController =
            TextEditingController(text: assetData['location']);
        TextEditingController notesController =
            TextEditingController(text: assetData['remarks']);

        return AlertDialog(
          title: const Text('Edit Asset'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Asset Name'),
                ),
                TextField(
                  controller: typeController,
                  decoration: const InputDecoration(labelText: 'Asset Type'),
                ),
                TextField(
                  controller: modelController,
                  decoration: const InputDecoration(labelText: 'Model'),
                ),
                TextField(
                  controller: serialController,
                  decoration: const InputDecoration(labelText: 'Serial Number'),
                ),
                TextField(
                  controller: statusController,
                  decoration: const InputDecoration(labelText: 'Status'),
                ),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                ),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'Notes'),
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
                await _firestore.collection('assets').doc(widget.assetId).update({
                  'assetName': nameController.text,
                  'assetType': typeController.text,
                  'model': modelController.text,
                  'serialNumber': serialController.text,
                  'status': statusController.text,
                  'location': locationController.text,
                  'remarks': notesController.text,
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Asset updated successfully.')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAsset(BuildContext context) async {
    try {
      await _firestore.collection('assets').doc(widget.assetId).delete();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting asset: $e')),
      );
    }
  }



//mula interface


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF092635),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Asset View',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF00ADB5),
        elevation: 10,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('assets').doc(widget.assetId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Asset not found'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionButton('Edit', Colors.blue, () => _editAsset(data)),
                    const SizedBox(width: 10),
                    _buildActionButton('Delete', Colors.red, () => _deleteAsset(context)),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isDetailsHidden = !_isDetailsHidden;
                        });
                      },
                      icon: Icon(
                        _isDetailsHidden ? Icons.visibility : Icons.visibility_off,
                        color: Color(0xFFA6E3E9),
                      ),
                    ),
                    IconButton(
                      onPressed: _showShareSheet,
                      icon: const Icon(Icons.share, color: Color(0xFFA6E3E9),),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                if (!_isDetailsHidden) ...[
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 10,
                    shadowColor: Colors.black.withOpacity(0.2),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [


// tempat image
                           GestureDetector(
                                  onTap: () => _showImageChangeAlert(data['imageUrl'] ?? ''),
                                  child: ClipOval(
                                    child: Builder(
                                      builder: (context) {
                                        debugPrint('Image URL: ${data['imageUrl']}'); // Debug Print di sini
                                        return Image.network(
                                          data['imageUrl'] ?? 'https://via.placeholder.com/150',
                                          height: 150,
                                          width: 150,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              height: 150,
                                              width: 150,
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.image, size: 80, color: Colors.grey),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),


             
                          const SizedBox(height: 20),
                          Text(
                            data['assetName'] ?? '',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            data['assetType'] ?? '',
                            style: const TextStyle(fontSize: 20, color: Colors.grey),
                          ),
                          const SizedBox(height: 20),
                          Table(
                            border: TableBorder.all(color: Colors.black.withOpacity(0.3)),
                            columnWidths: const {
                              0: FixedColumnWidth(120),
                              1: FixedColumnWidth(200),
                            },
                            children: [
                              _buildTableRow('Model:', data['model']),
                              _buildTableRow('Serial Number:', data['serialNumber']),
                              _buildTableRow('Status:', data['status']),
                              _buildTableRow('Purchase Date:', data['purchaseDate']),
                              _buildTableRow('Location:', data['location']),
                              _buildTableRow('Assigned To:', data['assignedTo']),
                              _buildTableRow('Maintenance Schedule:', data['maintenanceSchedule']),
                              _buildTableRow('Last Maintenance:', data['lastMaintenance']),
                              _buildTableRow('Notes:', data['remarks']),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  const Text(
                    'Details are hidden.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildShareButton(IconData icon, String label) {
    return Column(
      children: [
        FloatingActionButton(
          onPressed: () {
            _showConfirmationDialog(label);
          },
          backgroundColor: Color(0xFFA6E3E9),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildActionButton(String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  TableRow _buildTableRow(String label, String? value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value ?? 'N/A'),
        ),
      ],
    );
  }

  void _showConfirmationDialog(String label) {
    String message = '';

    // Set the message based on the label (action type)
    if (label == 'Email') {
      message = 'Are you sure you want to share via Email?';
    } else if (label == 'Telegram') {
      message = 'Are you sure you want to share via Telegram?';
    } else if (label == 'Generate PDF') {
      message = 'Are you sure you want to generate a PDF?';
    }

    // Show the confirmation dialog
    showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Action'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog

            // Show a dialog with a green tick icon
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 60,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        label == 'Email'
                            ? 'Email shared successfully!'
                            : label == 'Telegram'
                                ? 'Telegram shared successfully!'
                                : 'PDF generated successfully!',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the success dialog
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          },
          child: const Text('Yes'),
        ),
      ],
    );
  },
);
}
}
