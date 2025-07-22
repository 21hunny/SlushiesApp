import 'package:flutter/material.dart';

class ConfirmPage extends StatefulWidget {
  const ConfirmPage({super.key});

  @override
  State<ConfirmPage> createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  bool addSugar = true;
  bool addWater = true;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String drink = args["drink"];
    final String machine = args["machine"];

    String getDrinkImage(String drinkName) {
      if (drinkName.contains("Mango")) {
        return "assets/images/mango.jpg";
      } else if (drinkName.contains("Pineapple")) {
        return "assets/images/pinapple.jpg";
      } else if (drinkName.contains("Strawberry")) {
        return "assets/images/strawberry.jpg";
      } else {
        return "assets/images/default_drink.jpg";
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFE4F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF001F54),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Confirm Order", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drink + Machine Info Card
            Card(
              color: Colors.white,
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        getDrinkImage(drink),
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "You're about to order:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4B0082),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Drink: $drink",
                      style: const TextStyle(fontSize: 16, color: Colors.pinkAccent),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Machine: $machine",
                      style: const TextStyle(fontSize: 16, color: Color(0xFF001F54)),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Sugar Toggle
            SwitchListTile(
              value: addSugar,
              onChanged: (val) {
                setState(() {
                  addSugar = val;
                });
              },
              title: const Text("Add Sugar"),
              activeColor: Colors.pinkAccent,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            ),

            // Water Toggle
            SwitchListTile(
              value: addWater,
              onChanged: (val) {
                setState(() {
                  addWater = val;
                });
              },
              title: const Text("Add Water"),
              activeColor: Colors.pinkAccent,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            ),

            const SizedBox(height: 30),

            // Confirm Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/payment',
                  arguments: {
                    'juice': drink,
                    'addSugar': addSugar,
                    'addWater': addWater,
                    'machine': machine,
                  },
                );
              },
              icon: const Icon(Icons.check_circle_outline, color: Colors.white),
              label: const Text("Confirm & Start"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
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
