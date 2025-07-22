import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  String? _selectedCardType;
  String juiceType = "";
  bool addSugar = true;
  bool addWater = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      juiceType = args['juice'] ?? "";
      addSugar = args['addSugar'] ?? true;
      addWater = args['addWater'] ?? true;
    }
  }

  Future<void> _saveOrderToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final digitsOnly = _cardNumberController.text.replaceAll(RegExp(r'\D'), '');
    final last4 = digitsOnly.length >= 4 ? digitsOnly.substring(digitsOnly.length - 4) : digitsOnly;

    try {
      await FirebaseFirestore.instance.collection('orders').add({
        'userId': user.uid,
        'juiceType': juiceType,
        'addSugar': addSugar,
        'addWater': addWater,
        'paymentStatus': 'Success',
        'cardDetails': {
          'cardType': _selectedCardType ?? '',
          'last4Digits': last4,
        },
        'timestamp': FieldValue.serverTimestamp(),
        'localTimestamp': Timestamp.now(), // Important to avoid disappearing orders
      });
    } catch (e) {
      print("Failed to save order: $e");
    }
  }

  void _processPayment() async {
    if (_selectedCardType == null ||
        _cardNumberController.text.isEmpty ||
        _expiryController.text.isEmpty ||
        _cvvController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all payment details.")),
      );
      return;
    }

    await _saveOrderToFirestore();

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/status',  // your order success/status page route
      (route) => false,
    );
  }

  int _getCardMaxLength() {
    return _selectedCardType == 'Amex' ? 15 + 3 : 16 + 3;
  }

  String _formatCardNumber(String input) {
    String cleaned = input.replaceAll(RegExp(r'\D'), '');
    List<String> parts = [];
    for (int i = 0; i < cleaned.length; i += 4) {
      parts.add(cleaned.substring(i, i + (i + 4 <= cleaned.length ? 4 : cleaned.length - i)));
    }
    return parts.join(' ');
  }

  void _onCardNumberChanged(String value) {
    String formatted = _formatCardNumber(value);
    if (formatted != value) {
      _cardNumberController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE4F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF001F54),
        title: const Text("Payment Details", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (juiceType.isNotEmpty) ...[
              Text(
                "Selected Juice: $juiceType",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4B0082),
                ),
              ),
              const SizedBox(height: 5),
              Text("Add Sugar: ${addSugar ? 'Yes' : 'No'}"),
              Text("Add Water: ${addWater ? 'Yes' : 'No'}"),
              const SizedBox(height: 20),
            ],
            const Text(
              "Choose Card Type",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4B0082)),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedCardType,
              hint: const Text("Select Card Type (Visa / MasterCard / Amex)"),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: ['Visa', 'MasterCard', 'Amex'].map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCardType = value;
                  _cardNumberController.clear();
                });
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              maxLength: _getCardMaxLength(),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(_selectedCardType == 'Amex' ? 15 : 16),
              ],
              onChanged: _onCardNumberChanged,
              decoration: InputDecoration(
                hintText: "Card Number (e.g., 1234 5678 9012 3456)",
                prefixIcon: const Icon(Icons.credit_card, color: Colors.pinkAccent),
                filled: true,
                fillColor: Colors.white,
                counterText: "",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _expiryController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                hintText: "MM/YY",
                prefixIcon: const Icon(Icons.calendar_today, color: Colors.pinkAccent),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _cvvController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              decoration: InputDecoration(
                hintText: "CVV Number",
                prefixIcon: const Icon(Icons.lock, color: Colors.pinkAccent),
                filled: true,
                fillColor: Colors.white,
                counterText: "",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _processPayment,
              icon: const Icon(Icons.payment, color: Colors.white),
              label: const Text("Pay Now"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF001F54),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
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
