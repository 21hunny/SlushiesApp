import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> saveOrderToFirestore({
  required String juice,
  required String machine,
  required String location,
  required bool sugar,
  required bool water,
}) async {
  try {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      throw Exception("User not logged in.");
    }

    await FirebaseFirestore.instance.collection('orders').add({
      'uid': uid, // 🔐 required for security rules
      'juice': juice,
      'machine': machine,
      'location': location,
      'sugar': sugar,
      'water': water,
      'timestamp': FieldValue.serverTimestamp(),
    });

    print('✅ Order saved successfully!');
  } catch (e) {
    print('❌ Failed to save order: $e');
  }
}
