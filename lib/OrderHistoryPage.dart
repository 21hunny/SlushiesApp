import 'package:flutter/material.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> orderHistory = ModalRoute.of(context)!.settings.arguments as List<String>? ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFFFE4F2), // Light pink background
      appBar: AppBar(
        backgroundColor: const Color(0xFF001F54), // Deep blue app bar
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Order History",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: orderHistory.isEmpty
            ? Center(
                child: Text(
                  "No orders placed yet!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink[900],
                  ),
                ),
              )
            : ListView.separated(
                itemCount: orderHistory.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final order = orderHistory[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pinkAccent.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.local_drink, color: Colors.pinkAccent),
                      title: Text(
                        order,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4B0082),
                        ),
                      ),
                      subtitle: Text(
                        "Order #${index + 1}",
                        style: TextStyle(color: Colors.pink[700]),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
