import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<String> drinks = const ["Mango", "Pinapple", "Mixed Fruit"];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange.shade700,
        elevation: 4,
        title: const Text("Slushies"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.local_drink, size: 40, color: Colors.green),
                const SizedBox(width: 10),
                Text(
                  "Select Your Drink",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Drink List
            Expanded(
              child: ListView.separated(
                itemCount: drinks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      title: Text(
                        drinks[index],
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      trailing: const Icon(Icons.local_drink, color: Colors.orange),
                      onTap: () {
                        Navigator.pushNamed(context, "/machines", arguments: drinks[index]);
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Bottom Buttons
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                
                _buildButton(context, "Info", Icons.info_outline, "/info"),
                _buildButton(context, "Order Status", Icons.check_circle_outline, "/status"),
                _buildButton(context, "Profile", Icons.person_outline, "/profile"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label, IconData icon, String route) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 11, 177, 33),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
    );
  }
}
