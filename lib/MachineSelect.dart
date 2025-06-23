import 'package:flutter/material.dart';

class MachineSelectPage extends StatelessWidget {
  const MachineSelectPage({super.key});

  final List<String> machines = const [
    "Galle - Machine 01",
    "Karapitiya - Machine 02",
    "Unawatuna - Machine 03",
    "Hikkaduwa - Machine 04",
    "Fort - Machine 05",
  ];

  @override
  Widget build(BuildContext context) {
    final selectedDrink = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.orange.shade700,
        title: const Text("Select Machine"),
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Drink selected heading
            Row(
              children: [
                const Icon(Icons.local_drink, color: Colors.orange, size: 30),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Selected Drink: $selectedDrink",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade800,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Machine list
            Expanded(
              child: ListView.separated(
                itemCount: machines.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.precision_manufacturing, color: Colors.orange),
                      title: Text(
                        machines[index],
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: const Text("Available"),
                      trailing: const Icon(Icons.chevron_right),
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
