import 'package:flutter/material.dart';

class ConfirmPage extends StatelessWidget {
  const ConfirmPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String drink = args["drink"];
    final String machine = args["machine"];

    // Example image based on drink name
    String getDrinkImage(String drinkName) {
      if (drinkName.contains("Mango")) {
        return "assets/images/mango.jpg";
      } else if (drinkName.contains("Pineapple")) {
        return "assets/images/pinapple.jpg";
      } else if (drinkName.contains("Strawberry")) {
        return "assets/images/strawberry.jpg";
      } else {
        return "assets/images/default_drink.jpg"; // Fallback image
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFE4F2), // Light pink background
      appBar: AppBar(
        backgroundColor: const Color(0xFF001F54), // Deep blue AppBar
        iconTheme: const IconThemeData(color: Colors.white), // White back arrow
        title: const Text(
          "Confirm Order",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    Text(
                      "You're about to order:",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4B0082), // Deep purple text
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

            const SizedBox(height: 30),

            // Confirm Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/payment');

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
