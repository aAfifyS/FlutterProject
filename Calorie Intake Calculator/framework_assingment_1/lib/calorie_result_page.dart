// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';

class CalorieResultPage extends StatelessWidget {
  const CalorieResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil data daripada halaman sebelumnya melalui arguments
    final Map<String, double> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, double>;
    final double calories = args['calories']!; // Keperluan kalori harian
    final double bmi = args['bmi']!; // BMI pengguna

    // Variabel untuk kategori BMI, warna dan posisi untuk penunjuk BMI
    String bmiCategory;
    Color bmiColor = Colors.white; // Warna default
    double position = 0; // Posisi default

    // Menentukan kategori BMI berdasarkan nilai BMI
    if (bmi < 16.0) {
      bmiCategory = 'Really Low Underweight';
      bmiColor = Colors.red; // Merah untuk BMI sangat rendah
      position = 0.0; // Posisi kotak pertama
    } else if (bmi < 18.5) {
      bmiCategory = 'Underweight';
      bmiColor = Colors.yellow; // Kuning untuk berat badan rendah
      position = 1.0; // Posisi kotak kedua
    } else if (bmi < 24.9) {
      bmiCategory = 'Normal Weight';
      bmiColor = Colors.green; // Hijau untuk berat badan normal
      position = 2.0; // Posisi kotak ketiga (tengah)
    } else if (bmi < 30.0) {
      bmiCategory = 'Slight Obesity';
      bmiColor = Colors.yellow[700]!; // Kuning gelap untuk obesiti ringan
      position = 3.0; // Posisi kotak keempat
    } else {
      bmiCategory = 'Really Obese';
      bmiColor = Colors.red[800]!; // Merah gelap untuk obesiti teruk
      position = 4.0; // Posisi kotak kelima
    }

    return Scaffold(
      backgroundColor: const Color(0xFF910A67), // Warna latar belakang halaman
      appBar: AppBar(
        title: const Text(
          'Calorie Result',
          style: TextStyle(color: Colors.white), // Warna teks AppBar
        ),
        backgroundColor: const Color.fromARGB(185, 56, 6, 95), // Warna AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Margin luar konten
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Kad untuk memaparkan hasil kalori dan BMI
              Card(
                elevation: 6, // Kesan bayang pada kad
                color: const Color(0xFF030637), // Warna latar belakang kad
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0), // Bentuk kad
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0), // Margin dalam kad
                  child: Column(
                    children: [
                      const Text(
                        'Based on your BMI you should have a daily calorie intake of: ',
                        style: TextStyle(fontSize: 22, color: Colors.white),
                        textAlign: TextAlign.center, // Pusatkan teks
                      ),
                      const SizedBox(height: 20), // Jarak antara teks dan hasil kalori
                      Text(
                        '${calories.toStringAsFixed(2)} kcal',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20), // Jarak antara kalori dan teks BMI
                      const Text(
                        'Your BMI is: ',
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ),
                      Text(
                        '${bmi.toStringAsFixed(2)} ($bmiCategory)',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24), // Jarak antara kad dan kotak BMI

              // Kotak penunjuk BMI berdasarkan kategori
              SizedBox(
                height: 120, // Tinggi kontainer untuk kotak BMI
                width: double.infinity, // Lebar penuh layar
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Pusatkan kotak
                  children: [
                    buildBmiBox(Colors.red[800]!, 0, position), // Kotak pertama
                    buildBmiBox(Colors.yellow[600]!, 1, position), // Kotak kedua
                    buildBmiBox(const Color.fromARGB(255, 11, 245, 22), 2, position), // Kotak ketiga
                    buildBmiBox(const Color.fromARGB(255, 221, 164, 20), 3, position), // Kotak keempat
                    buildBmiBox(Colors.red[700]!, 4, position), // Kotak kelima
                  ],
                ),
              ),
              const SizedBox(height: 24), // Jarak antara kotak dan jadual BMI

              // Jadual Status BMI
              Card(
                elevation: 6,
                color: const Color(0xFF030637), // Warna latar belakang kad
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0), // Bentuk kad
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Text(
                        'BMI Status Table: ',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12), // Jarak antara teks dan jadual
                      Table(
                        border: TableBorder.all(
                          color: Colors.white, // Warna border jadual
                          width: 1, // Ketebalan border
                        ),
                        children: const [
                          // Baris pertama jadual
                          TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Really Low Underweight',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'BMI < 16.0',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Baris kedua jadual
                          TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Underweight',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'BMI 16.0–18.5',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Baris ketiga jadual
                          TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Normal Weight',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'BMI 18.5–24.9',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Baris keempat jadual
                          TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Slight Obesity',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'BMI 25.0–29.9',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Baris kelima jadual
                          TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Really Obese',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'BMI ≥ 30.0',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24), // Jarak antara jadual dan butang

              // Butang untuk kembali ke halaman utama
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(185, 40, 1, 58),
                  padding:
                      const EdgeInsets.symmetric(vertical: 16.0, horizontal: 48.0),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/'); // Navigasi ke halaman utama
                },
                child: const Text(
                  'Back to Home',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi untuk membina kotak BMI
  Widget buildBmiBox(Color boxColor, double boxIndex, double currentPosition) {
    return Stack(
      alignment: Alignment.center, // Susun elemen ke tengah kotak
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500), // Tempoh animasi
          height: 80, // Tinggi kotak
          width: 60, // Lebar kotak
          margin: const EdgeInsets.symmetric(horizontal: 5), // Margin antara kotak
          decoration: BoxDecoration(
            color: boxIndex == currentPosition
                ? boxColor // Warna aktif berdasarkan posisi semasa
                : boxColor.withOpacity(0.5), // Warna tidak aktif (transparan)
            borderRadius: BorderRadius.circular(12), // Sudut melengkung kotak
          ),
        ),
        // Penunjuk anak panah atas jika kotak aktif
        if (boxIndex == currentPosition)
          const Positioned(
            top: -10,
            child: Icon(
              Icons.arrow_drop_up,
              color: Colors.white,
              size: 30,
            ),
          ),
        // Penunjuk anak panah bawah jika kotak aktif
        if (boxIndex == currentPosition)
          const Positioned(
            bottom: -10,
            child: Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
              size: 30,
            ),
          ),
      ],
    );
  }
}