import 'package:flutter/material.dart';
import 'dart:async';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  String statusMessage = "Your drink is being prepared...";
  bool isDone = false;

  @override
  void initState() {
    super.initState();

    // ✅ Simulate status change after 3 seconds
    Timer(const Duration(seconds: 3), () {
      setState(() {
        statusMessage = "✅ Order Completed! Enjoy your drink!";
        isDone = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE4F2), // Light pink background
      appBar: AppBar(
        backgroundColor: const Color(0xFF001F54), // Deep blue app bar
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Order Status",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ✅ Animated GIF or Image
              SizedBox(
                width: 150,
                height: 150,
                child: Image.asset(
                  isDone
                      ? "assets/images/original.gif"      // ✅ Success GIF
                      : "assets/images/original.gif",   // ✅ Preparing GIF (you can use different GIFs if you want)
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),

              Text(
                statusMessage,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDone ? Colors.green : const Color(0xFF4B0082),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              ElevatedButton.icon(
                icon: const Icon(Icons.home, color: Colors.white),
                label: const Text("Back to Home"),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
