import 'package:flutter/material.dart';

class MachineSelectPage extends StatelessWidget {
  const MachineSelectPage({super.key});

  final List<String> machines = const [
    "Galle - Machine 01",
    "Weligama - Machine 02",
    "Unawatuna - Machine 03",
    "Hikkaduwa - Machine 04",
    "Fort - Machine 05",
  ];

  final List<String> machineImages = const [
    "assets/images/galle.jpeg", // Galle
    "assets/images/weligama.jpeg", // Weligama
    "assets/images/Unawatuna.jpg", // Unawatuna
    "assets/images/hikkaduwa.jpg", // Hikkaduwa
    "assets/images/fort.jpg", // Fort
  ];

  @override
  Widget build(BuildContext context) {
    final selectedDrink = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      backgroundColor: const Color(0xFFFFE4F2), // Light pink background
      appBar: AppBar(
        backgroundColor: const Color(0xFF001F54), // Deep blue app bar
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // ✅ White back arrow
        title: const Text(
          "Select Machine",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Selected drink heading (without icon)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.pink[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Selected Drink: $selectedDrink",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4B0082), // Deep purple text
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Machine list
            Expanded(
              child: ListView.separated(
                itemCount: machines.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          machineImages[index],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        machines[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF001F54), // Dark blue title
                        ),
                      ),
                      subtitle: const Text(
                        "Available",
                        style: TextStyle(color: Colors.pinkAccent),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Color(0xFF001F54),
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          "/confirm",
                          arguments: {
                            "drink": selectedDrink,
                            "machine": machines[index],
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
