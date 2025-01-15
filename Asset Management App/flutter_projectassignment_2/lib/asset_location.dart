import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssetLocation extends StatefulWidget {
  const AssetLocation({super.key});

  @override
  _AssetLocationState createState() => _AssetLocationState();
}

class _AssetLocationState extends State<AssetLocation> {
  // Lokasi lengkap dengan koordinat tambahan
  final Map<String, LatLng> _locationCoordinates = {
    "Johor": LatLng(1.4927, 103.7414),
    "Kedah": LatLng(6.1216, 100.3695),
    "Kelantan": LatLng(6.1254, 102.2383),
    "Melaka": LatLng(2.1896, 102.2501),
    "Negeri Sembilan": LatLng(2.7297, 101.9381),
    "Pahang": LatLng(3.8085, 103.3260),
    "Perak": LatLng(4.5975, 101.0901),
    "Perlis": LatLng(6.4402, 100.1986),
    "Pulau Pinang": LatLng(5.4171, 100.3295),
    "Sabah": LatLng(5.9788, 116.0723),
    "Sarawak": LatLng(1.5529, 110.3584),
    "Selangor": LatLng(3.0733, 101.5185),
    "Terengganu": LatLng(5.3302, 103.1420),
    "Kuala Lumpur": LatLng(3.1390, 101.6869),
    "Putrajaya": LatLng(2.9264, 101.6964),
    "Labuan": LatLng(5.2767, 115.2417),
    "Johor Bahru": LatLng(1.4927, 103.7414),
    "Alor Setar": LatLng(6.1216, 100.3695),
    "Kota Bharu": LatLng(6.1254, 102.2383),
    "Melaka City": LatLng(2.1896, 102.2501),
    "Seremban": LatLng(2.7297, 101.9381),
    "Kuantan": LatLng(3.8085, 103.3260),
    "Ipoh": LatLng(4.5975, 101.0901),
    "Kangar": LatLng(6.4402, 100.1986),
    "George Town": LatLng(5.4171, 100.3295),
    "Kota Kinabalu": LatLng(5.9788, 116.0723),
    "Kuching": LatLng(1.5529, 110.3584),
    "Shah Alam": LatLng(3.0733, 101.5185),
    "Kuala Terengganu": LatLng(5.3302, 103.1420),
    "Singapore": LatLng(1.3521, 103.8198),
    "Bangkok": LatLng(13.7563, 100.5018),
    "Chiang Mai": LatLng(18.7883, 98.9853),
    "Phuket": LatLng(7.8804, 98.3923),
    "Hat Yai": LatLng(6.9968, 100.4714),
    "Songkhla": LatLng(7.1978, 100.5953),
    "Jakarta": LatLng(-6.2088, 106.8456),
    "Aceh": LatLng(5.5617, 95.3167),
    "North Sumatra": LatLng(3.5852, 98.6756),
    "West Sumatra": LatLng(-0.9471, 100.4172),
    "Riau": LatLng(0.5071, 101.4478),
    "South Sumatra": LatLng(-2.9909, 104.7565),
    "West Java": LatLng(-6.9147, 107.6098),
    "Central Java": LatLng(-6.9667, 110.4167),
    "Yogyakarta": LatLng(-7.7971, 110.3705),
    "East Java": LatLng(-7.2492, 112.7508),
    "Bali": LatLng(-8.6500, 115.2167),
    "Banda Aceh": LatLng(5.5617, 95.3167),
    "Medan": LatLng(3.5852, 98.6756),
    "Padang": LatLng(-0.9471, 100.4172),
    "Pekanbaru": LatLng(0.5071, 101.4478),
    "Palembang": LatLng(-2.9909, 104.7565),
    "Bandung": LatLng(-6.9147, 107.6098),
    "Semarang": LatLng(-6.9667, 110.4167),
    "Denpasar": LatLng(-8.6500, 115.2167),
  };

  // Fungsi untuk mencari koordinat lokasi
  LatLng _getCoordinates(String location) {
    final normalizedLocation = location.toLowerCase();
    final coordinates = _locationCoordinates.entries
        .firstWhere(
          (entry) => entry.key.toLowerCase() == normalizedLocation,
          orElse: () => MapEntry("", LatLng(0, 0)),
        )
        .value;
    return coordinates;
  }

  final MapController _mapController = MapController();
  String? _selectedAssetId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Asset Locations"),
        backgroundColor: const Color(0xFF00ADB5),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('assets').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final assets = snapshot.data!.docs.where((doc) {
            final assetName = doc['assetName'] ?? '';
            final location = doc['location'] ?? '';
            return assetName.isNotEmpty && location.isNotEmpty;
          }).toList();

          if (assets.isEmpty) {
            return const Center(
              child: Text(
                "No assets available to display.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          // Buat marker
          final markers = assets.map((doc) {
            final location = doc['location'] ?? "";
            final coordinates = _getCoordinates(location);
            final isSelected = _selectedAssetId == doc.id;

            return Marker(
              point: coordinates,
              builder: (context) => GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedAssetId = doc.id;
                  });
                  _mapController.move(coordinates, 14.0);
                },
                child: Icon(
                  Icons.location_on,
                  color: isSelected ? Colors.red : Colors.blue,
                  size: isSelected ? 40.0 : 30.0,
                ),
              ),
            );
          }).toList();

          return Column(
            children: [
              Expanded(
                flex: 2,
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    onPositionChanged: (position, hasGesture) {
                      if (hasGesture) {
                        setState(() {
                          _selectedAssetId = null;
                        });
                      }
                    },
                    center: LatLng(4.2105, 101.9758),
                    zoom: 6.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    MarkerLayer(markers: markers),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: ListView.builder(
                  itemCount: assets.length,
                  itemBuilder: (context, index) {
                    final asset = assets[index];
                    final location = asset['location'] ?? "";
                    final assetName = asset['assetName'] ?? "Unknown";

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAssetId = asset.id;
                        });
                        final coordinates = _getCoordinates(location);
                        _mapController.move(coordinates, 14.0);
                      },
                      child: Card(
                        color: const Color(0xFF71C9CE),
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    assetName,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Location: $location",
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.location_on,
                                color: _selectedAssetId == asset.id ? Colors.red : Colors.blue,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
