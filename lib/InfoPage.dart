import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE4F2), // Light pink background
      appBar: AppBar(
        backgroundColor: const Color(0xFF001F54), // Deep blue app bar
        iconTheme: const IconThemeData(color: Colors.white), // White back arrow
        title: const Text(
          "About Slushies",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Slushies Image or Logo
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/info.jpeg',  // <-- Add your app logo/image here
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            const Text(
              "Welcome to Slushies!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4B0082), // Purple like HomePage titles
              ),
            ),
            const SizedBox(height: 16),

            // Description Card
            Card(
              color: Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Slushies is your smart, refreshing juice solution. We offer a variety of fresh, fruity beverages made through intelligent vending machines placed across cities.\n\n"
                  "Whether you love Mango, Pineapple, or Strawberry, we’ve got you covered!\n\n"
                  "Use our app to select your favorite juice, choose the nearest machine, and track your order status. Everything is automated, hygienic, and lightning fast.\n\n"
                  "Founded in 2025, Slushies is driven by a mission to bring convenience, flavor, and technology together for a cool experience – one cup at a time.",
                  style: const TextStyle(fontSize: 16, color: Color(0xFF4B0082)), // Purple text
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Contact Info
            Row(
              children: const [
                Icon(Icons.email, color: Colors.pinkAccent),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Contact us: support@slushies.com",
                    style: TextStyle(color: Colors.pinkAccent),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                Icon(Icons.phone, color: Colors.pinkAccent),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Hotline: +94 77 123 4567",
                    style: TextStyle(color: Colors.pinkAccent),
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
              icon: const Icon(Icons.home, color: Colors.white),
              label: const Text("Back to Home"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
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
