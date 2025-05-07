import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<Map<String, dynamic>> tanaman = [
    {
      'nama': 'Sawi',
      'ph': 6.5,
      'suhu': 25.0,
      'nutrisi': 800,
      'tinggi_air': 55,
    },
    {
      'nama': 'Bayam',
      'ph': 6.2,
      'suhu': 24.5,
      'nutrisi': 700,
      'tinggi_air': 50,
    },
    {
      'nama': 'Selada',
      'ph': 6.0,
      'suhu': 23.5,
      'nutrisi': 750,
      'tinggi_air': 60,
    },
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final selectedPlant = tanaman[selectedIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFEFF4F8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Lokasi dan Profil
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Monitoring\nHidroponik",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage("https://via.placeholder.com/150"),
                  )
                ],
              ),
              const SizedBox(height: 20),

              // Pilihan Tanaman
              SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: tanaman.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final isSelected = index == selectedIndex;
                    return GestureDetector(
                      onTap: () => setState(() {
                        selectedIndex = index;
                      }),
                      child: Container(
                        width: 90,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.green : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.eco, size: 30, color: isSelected ? Colors.white : Colors.green),
                            const SizedBox(height: 6),
                            Text(
                              tanaman[index]['nama'],
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),
              Text(
                "Status Tanaman: ${selectedPlant['nama']}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Status Monitoring
              Expanded(
                child: ListView(
                  children: [
                    statusCard(
                      title: "pH Air",
                      value: selectedPlant['ph'].toString(),
                      unit: "",
                      color: _getColor(selectedPlant['ph'], 5.5, 7.5),
                    ),
                    statusCard(
                      title: "Suhu",
                      value: "${selectedPlant['suhu']}°C",
                      unit: "",
                      color: _getColor(selectedPlant['suhu'], 18, 30),
                    ),
                    statusCard(
                      title: "Nutrisi",
                      value: "${selectedPlant['nutrisi']} ppm",
                      unit: "",
                      color: _getColor(selectedPlant['nutrisi'].toDouble(), 500, 1000),
                    ),
                    statusCard(
                      title: "Tinggi Air",
                      value: "${selectedPlant['tinggi_air']}%",
                      unit: "",
                      color: _getColor(selectedPlant['tinggi_air'].toDouble(), 40, 60),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget statusCard({required String title, required String value, required String unit, required Color color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [          Text(title, style: const TextStyle(fontSize: 16, color: Colors.white)),
          Text(value, style: const TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }

  Color _getColor(double value, double min, double max) {
    if (value < min || value > max) {
      return Colors.red;
    }
    return Colors.green;
  }
}
