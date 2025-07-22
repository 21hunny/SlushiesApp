import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> drinks = [
    {
      "name": "Mango Juice",
      "price": 12.65,
      "image": "assets/images/mango.jpg",
      "sugar": false,
      "water": false,
    },
    {
      "name": "Pineapple Juice",
      "price": 13.99,
      "image": "assets/images/pinapple.jpg",
      "sugar": false,
      "water": false,
    },
    {
      "name": "Strawberry Juice",
      "price": 11.27,
      "image": "assets/images/strawberry.jpg",
      "sugar": false,
      "water": false,
    },
  ];

  final List<String> orderHistory = [];

  void toggleSugar(int index) {
    setState(() {
      drinks[index]['sugar'] = !drinks[index]['sugar'];
    });
  }

  void toggleWater(int index) {
    setState(() {
      drinks[index]['water'] = !drinks[index]['water'];
    });
  }

  void placeOrder(String drinkName) {
    setState(() {
      orderHistory.add(drinkName);
    });
    Navigator.pushNamed(context, "/machines", arguments: drinkName);
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Future.microtask(() {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE4F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF001F54),
        title: const Text(
          'Slushies Menu 🍹',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF001F54),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.account_circle, size: 60, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Welcome to Slushies!',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.pinkAccent),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.pinkAccent),
              title: const Text('Info'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/info');
              },
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.pinkAccent),
              title: const Text('Order History'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/orderHistory', arguments: orderHistory);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Logout'),
              onTap: logout,
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: drinks.length,
          separatorBuilder: (_, __) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            final drink = drinks[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pinkAccent.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            drink["image"],
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                drink["name"],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4B0082),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "\$${drink["price"].toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: Colors.pinkAccent,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF001F54),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => placeOrder(drink["name"]),
                          child: const Text(
                            "Order",
                            style: TextStyle(fontSize: 13, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: drink['sugar'] ? Colors.pinkAccent : Colors.pink[100],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => toggleSugar(index),
                          child: Text(
                            "Add Sugar",
                            style: TextStyle(
                              fontSize: 13,
                              color: drink['sugar'] ? Colors.white : Colors.pink[900],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: drink['water'] ? Colors.pinkAccent : Colors.pink[100],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => toggleWater(index),
                          child: Text(
                            "Add Water",
                            style: TextStyle(
                              fontSize: 13,
                              color: drink['water'] ? Colors.white : Colors.pink[900],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
