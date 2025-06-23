import 'package:flutter/material.dart';

class ConfirmPage extends StatelessWidget {
  const ConfirmPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String drink = args["drink"];
    final String machine = args["machine"];

    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange.shade700,
        title: const Text("Confirm Order"),
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Drink + Machine Info Card
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Icon(Icons.local_drink, size: 60, color: Colors.orange),
                    const SizedBox(height: 16),
                    Text(
                      "You're about to order:",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade800,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Drink: $drink",
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      "Machine: $machine",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Confirm Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, "/status", arguments: machine);
              },
              icon: const Icon(Icons.check_circle_outline),
              label: const Text("Confirm & Start"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 11, 177, 33),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
