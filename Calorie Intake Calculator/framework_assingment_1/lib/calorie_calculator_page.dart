import 'package:flutter/material.dart';

class CalorieCalculatorPage extends StatefulWidget {
  const CalorieCalculatorPage({super.key});

  @override
  State<CalorieCalculatorPage> createState() => _CalorieCalculatorPageState();
}

class _CalorieCalculatorPageState extends State<CalorieCalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  String? gender; // Variabel untuk menyimpan jantina
  int? age; // Variabel untuk menyimpan umur
  double? height; // Variabel untuk menyimpan tinggi
  double? weight; // Variabel untuk menyimpan berat
  String activityLevel = '1-2 times a month'; // Tahap aktiviti pengguna

  // Fungsi untuk mengira keperluan kalori berdasarkan BMR dan tahap aktiviti
  double calculateCalories() {
    // Mengira BMR (Basal Metabolic Rate) berdasarkan jantina
    double bmr = gender == 'Male'
        ? 88.362 + (13.397 * weight!) + (4.799 * height!) - (5.677 * age!)
        : 447.593 + (9.247 * weight!) + (3.098 * height!) - (4.330 * age!);

    // Menyesuaikan kalori berdasarkan tahap aktiviti
    switch (activityLevel) {
      case '1-2 times a month':
        return bmr * 1.2; // Rendah
      case '3 times a week':
        return bmr * 1.55; // Sederhana
      case 'everyday':
        return bmr * 1.9; // Tinggi
      default:
        return bmr;
    }
  }

  // Fungsi untuk mengira BMI (Body Mass Index)
  double calculateBMI() {
    return weight! / ((height! / 100) * (height! / 100));
  }

  // Fungsi untuk memaparkan mesej amaran jika input tidak sah
  void showAlert(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invalid Input'), // Tajuk dialog
        content: Text(message), // Mesej dialog
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Tutup dialog
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calorie Calculator',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 78, 2, 86), // Warna AppBar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Bahagian Katalog dengan gambar di dalam kad
            Card(
              elevation: 5,
              color: const Color.fromARGB(255, 6, 11, 109),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 200.0, // Ketinggian katalog
                    child: PageView(
                      children: [
                        // Gambar pertama
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Image.asset(
                            'lib/image/quotes1.jpeg',
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Gambar kedua
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Image.asset(
                            'lib/image/quotes2.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Gambar ketiga
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Image.asset(
                            'lib/image/quotes3.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // Jarak antara katalog dan borang

            // Kad untuk bahagian borang
            Card(
              elevation: 5,
              color: const Color(0xFF030637),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dropdown untuk memilih jantina
                      DropdownButtonFormField<String>(
                        value: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value;
                          });
                        },
                        items: ['Male', 'Female']
                            .map((label) => DropdownMenuItem(
                                value: label, child: Text(label)))
                            .toList(),
                        decoration: const InputDecoration(
                          labelText: 'Gender',
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        validator: (value) =>
                            value == null ? 'Please select your gender' : null,
                        style: const TextStyle(color: Colors.white),
                        dropdownColor: const Color.fromARGB(255, 231, 115, 194),
                      ),
                      const SizedBox(height: 12),
                      // Input untuk umur
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Age (years)',
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          age = int.tryParse(value);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your age';
                          }
                          final ageValue = int.tryParse(value);
                          if (ageValue == null || ageValue <= 0) {
                            return 'Please enter a valid positive age';
                          }
                          return null;
                        },
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(height: 12),
                      // Input untuk tinggi
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Height (cm)',
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          height = double.tryParse(value);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your height';
                          }
                          final heightValue = double.tryParse(value);
                          if (heightValue == null || heightValue <= 0) {
                            return 'Please enter a valid positive height';
                          }
                          return null;
                        },
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(height: 12),
                      // Input untuk berat
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Weight (kg)',
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          weight = double.tryParse(value);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your weight';
                          }
                          final weightValue = double.tryParse(value);
                          if (weightValue == null || weightValue <= 0) {
                            return 'Please enter a valid positive weight';
                          }
                          return null;
                        },
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(height: 12),
                      // Dropdown untuk tahap aktiviti
                      DropdownButtonFormField<String>(
                        value: activityLevel,
                        onChanged: (value) {
                          setState(() {
                            activityLevel = value!;
                          });
                        },
                        items: [
                          '1-2 times a month',
                          '3 times a week',
                          'everyday'
                        ]
                            .map((level) => DropdownMenuItem(
                                value: level, child: Text(level)))
                            .toList(),
                        decoration: const InputDecoration(
                          labelText: 'Activity Level',
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        dropdownColor: const Color.fromARGB(255, 231, 115, 194),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      // Butang untuk ke halaman seterusnya
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 208, 6, 154),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Jika borang sah, kira kalori dan BMI
                              final calories = calculateCalories();
                              final bmi = calculateBMI();

                              // Navigasi ke halaman keputusan
                              Navigator.pushNamed(
                                context,
                                '/result',
                                arguments: {'calories': calories, 'bmi': bmi},
                              );
                            } else {
                              // Papar mesej jika input tidak sah
                              showAlert('Please fill in all fields correctly.');
                            }
                          },
                          child: const Text('Next',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF910A67), // Warna latar belakang skrin
    );
  }
}
