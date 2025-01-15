import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddAssetScreen extends StatefulWidget {
  const AddAssetScreen({super.key});

  @override
  State<AddAssetScreen> createState() => _AddAssetScreenState();
}

class _AddAssetScreenState extends State<AddAssetScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController assetNameController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController serialNumberController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  final TextEditingController purchaseDateController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController assignedToController = TextEditingController();
  final TextEditingController maintenanceScheduleController = TextEditingController();
  final TextEditingController lastMaintenanceController = TextEditingController();

  final _assets = ['Vehicle', 'Building', 'Appliances', 'Land'];
  final _status = ['Active', 'Inactive', 'Maintenance'];

  String dropdownValue = 'Vehicle';
  String dropdownValue2 = 'Active';

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _saveAsset() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('assets').add({
          'userId': user.uid,
          'assetName': assetNameController.text,
          'assetType': dropdownValue,
          'model': modelController.text,
          'serialNumber': serialNumberController.text,
          'status': dropdownValue2,
          'remarks': remarksController.text,
          'purchaseDate': purchaseDateController.text,
          'location': locationController.text,
          'assignedTo': assignedToController.text,
          'maintenanceSchedule': maintenanceScheduleController.text,
          'lastMaintenance': lastMaintenanceController.text,
          'createdAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Asset saved successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving asset: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Asset'), backgroundColor: Color(0xFF00ADB5)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: assetNameController,
                decoration: const InputDecoration(
                  labelText: 'Asset Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: modelController,
                decoration: const InputDecoration(
                  labelText: 'Model',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: serialNumberController,
                decoration: const InputDecoration(
                  labelText: 'Serial Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: purchaseDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Purchase Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context, purchaseDateController),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: assignedToController,
                decoration: const InputDecoration(
                  labelText: 'Assigned To',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: dropdownValue,
                decoration: const InputDecoration(
                  labelText: 'Asset Type',
                  border: OutlineInputBorder(),
                ),
                items: _assets.map((String asset) {
                  return DropdownMenuItem(value: asset, child: Text(asset));
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: dropdownValue2,
                decoration: const InputDecoration(
                  labelText: 'Asset Status',
                  border: OutlineInputBorder(),
                ),
                items: _status.map((String status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue2 = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: maintenanceScheduleController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Maintenance Schedule',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context, maintenanceScheduleController),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: lastMaintenanceController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Last Maintenance',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context, lastMaintenanceController),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: remarksController,
                decoration: const InputDecoration(
                  labelText: 'Remarks/Notes',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveAsset,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
