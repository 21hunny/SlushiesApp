import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.orange.shade700,
        title: const Text("About Slushies"),
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo or Icon
            const Icon(
              Icons.local_drink,
              size: 80,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              "Welcome to Slushies!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade800,
                  ),
            ),
            const SizedBox(height: 16),

            // Description Card
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Slushies is your smart, refreshing juice solution. We offer a variety of fresh, fruity beverages made through intelligent vending machines placed across cities. Whether you love Mango, Pineapple, or a Mix Berry blast, we’ve got you covered!\n\n"
                  "Use our app to select your favorite juice, choose the nearest machine, and track your order status. Everything is automated, hygienic, and lightning fast.\n\n"
                  "Founded in 2025, Slushies is driven by a mission to bring convenience, flavor, and tech together for a cool experience – one cup at a time.",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Contact Info
            Row(
              children: [
                const Icon(Icons.email, color: Colors.orange),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Contact us: support@slushies.com",
                    style: TextStyle(color: Colors.orange.shade700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.orange),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Hotline: +94 77 123 4567",
                    style: TextStyle(color: Colors.orange.shade700),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Back to Home Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              },
              icon: const Icon(Icons.home),
              label: const Text("Back"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
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
