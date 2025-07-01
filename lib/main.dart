import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'SignupPage.dart';
import 'HomePage.dart';
import 'MachineSelect.dart';
import 'ConformOrder.dart';
import 'StatusPage.dart';
import 'InfoPage.dart';
import 'ProfilePage.dart';
import 'PaymentPage.dart';
import 'OrderHistoryPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Shared in-memory user map (if still used somewhere)
final Map<String, String> users = {"yohani@gmail.com": "123456"};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Slushies App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFFFFE6EE), // Light pink background (optional global)
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const HomePage(),
        '/machines': (context) => const MachineSelectPage(),
        '/confirm': (context) => const ConfirmPage(),
        '/status': (context) => const StatusPage(),
        '/info': (context) => const InfoPage(),
        '/profile': (context) => const ProfilePage(),
        '/payment': (context) => const PaymentPage(),
        '/orderHistory': (context) => const OrderHistoryPage(),
      },
    );
  }
}
