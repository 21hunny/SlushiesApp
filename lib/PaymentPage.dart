import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  String machine = "Unknown Machine";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ✅ Get machine name from previous page (ConfirmPage)
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null && args is String) {
      machine = args;
    }
  }

  void _processPayment() {
    if (_selectedCardType == null ||
        _cardNumberController.text.isEmpty ||
        _expiryController.text.isEmpty ||
        _cvvController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all payment details.")),
      );
      return;
    }

    // ✅ Navigate to StatusPage, passing machine name
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/status',
      (route) => false,
      arguments: machine,
    );
  }

  int _getCardMaxLength() {
    if (_selectedCardType == 'Amex') {
      return 15 + 3; // 15 digits + spaces
    } else {
      return 16 + 3; // 16 digits + spaces
    }
  }

  String _formatCardNumber(String input) {
    String cleaned = input.replaceAll(RegExp(r'\D'), '');
    List<String> parts = [];

    if (_selectedCardType == 'Amex') {
      for (int i = 0; i < cleaned.length; i += 4) {
        parts.add(cleaned.substring(i, i + (i + 4 <= cleaned.length ? 4 : cleaned.length - i)));
      }
    } else {
      for (int i = 0; i < cleaned.length; i += 4) {
        parts.add(cleaned.substring(i, i + (i + 4 <= cleaned.length ? 4 : cleaned.length - i)));
      }
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

            // Card Number
            TextFormField(
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              maxLength: _getCardMaxLength(),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(
                  _selectedCardType == 'Amex' ? 15 : 16,
                ),
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

            // Expiry Date
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

            // CVV
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
