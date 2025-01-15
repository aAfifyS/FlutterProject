import 'package:flutter/material.dart';

class HelpDeskScreen extends StatefulWidget {
  const HelpDeskScreen({super.key});

  @override
 @override
  _HelpDeskScreenState createState() => _HelpDeskScreenState();
}

class _HelpDeskScreenState extends State<HelpDeskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  bool _tncAccepted = false;

  void _resetForm() {
    _nameController.clear();
    _emailController.clear();
    _detailsController.clear();
    setState(() {
      _tncAccepted = false;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (!_tncAccepted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please accept the Terms and Conditions.')),
        );
        return;
      }

      // Submit logic (you can replace this with actual logic such as API calls)
      print('Name: ${_nameController.text}');
      print('Email: ${_emailController.text}');
      print('Details: ${_detailsController.text}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form submitted successfully!')),
      );

      _resetForm(); // Reset the form after submission
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFA6E3E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00ADB5),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('HelpDesk'),
            SizedBox(width: 8),
            Icon(Icons.headset_mic), // HelpDesk icon
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name Field
                const Text('Name:', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email Field
                const Text('Email:', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Issue Details
                const Text('Issued Details:', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _detailsController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Describe your issue',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide details about the issue';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Upload Document
                const Text('Upload supporting document:', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                IconButton(
                  icon: const Icon(Icons.cloud_upload, size: 32),
                  onPressed: () {
                    // TODO: Add file upload logic here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Upload functionality coming soon!')),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Checkbox and Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _tncAccepted,
                          onChanged: (value) {
                            setState(() {
                              _tncAccepted = value!;
                            });
                          },
                        ),
                        const Text('You have read the TnC'),
                      ],
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _resetForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                          ),
                          child: const Text('Send'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


