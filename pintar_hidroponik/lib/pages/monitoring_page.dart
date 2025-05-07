import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inisialisasi Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MonitoringPage(),
    );
  }
}

class MonitoringPage extends StatefulWidget {
  const MonitoringPage({super.key});

  @override
  State<MonitoringPage> createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  final firestore = FirebaseFirestore.instance;
  double suhu = 0;
  double ph = 0;
  int tinggiAir = 0;
  int nutrisi = 0;
  bool isAuto = false;

  @override
  void initState() {
    super.initState();
    ambilData();
  }

  void ambilData() {
    firestore.collection("hidroponik").doc("latest").snapshots().listen((docSnapshot) {
      final data = docSnapshot.data();
      if (data != null) {
        setState(() {
          tinggiAir = data["tinggi_air"] ?? 0;
          ph = (data["ph"] ?? 0).toDouble();
          nutrisi = data["nutrisi"] ?? 0;
          suhu = (data["suhu"] ?? 0).toDouble();
          isAuto = data["otomatis"] ?? false;
        });
      }
    });
  }

  void updateOtomatis(bool value) {
    firestore.collection("monitoring").doc("data").update({"otomatis": value});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Menu Monitoring")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                MonitoringCard(
                  icon: Icons.thermostat,
                  iconColor: Colors.orange,
                  value: "${suhu.toStringAsFixed(1)}°C",
                  label: "Suhu",
                ).animate().fadeIn(duration: 500.ms).scale(),
                MonitoringCard(
                  icon: Icons.science,
                  iconColor: Colors.teal,
                  value: ph.toString(),
                  label: "pH",
                ).animate().fadeIn(duration: 600.ms).scale(),
                MonitoringCard(
                  icon: Icons.water_drop,
                  iconColor: Colors.blue,
                  value: "$tinggiAir%",
                  label: "Tinggi Air",
                ).animate().fadeIn(duration: 700.ms).scale(),
                MonitoringCard(
                  icon: Icons.local_florist,
                  iconColor: Colors.green,
                  value: "$nutrisi ppm",
                  label: "Nutrisi",
                ).animate().fadeIn(duration: 800.ms).scale(),
              ],
            ),
            const SizedBox(height: 20),
            AutomaticFertilizerCard(
              isActive: isAuto,
              onToggle: (value) {
                setState(() {
                  isAuto = value;
                });
                updateOtomatis(value);
              },
            ).animate().fadeIn(duration: 1000.ms).slideY(begin: 0.3),
          ],
        ),
      ),
    );
  }
}

class MonitoringCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const MonitoringCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: iconColor),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class AutomaticFertilizerCard extends StatelessWidget {
  final bool isActive;
  final ValueChanged<bool> onToggle;

  const AutomaticFertilizerCard({
    super.key,
    required this.isActive,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.greenAccent, Colors.green],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.spa_outlined, color: Colors.white, size: 36),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Mode Otomatis Pupuk",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isActive
                        ? "Pemberian pupuk berjalan otomatis"
                        : "Mode otomatis nonaktif",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Switch.adaptive(
            value: isActive,
            activeColor: Colors.white,
            onChanged: onToggle,
          ),
        ],
      ),
    );
  }
}