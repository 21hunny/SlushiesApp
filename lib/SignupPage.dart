import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  late AnimationController _logoAnimationController;
  late Animation<Offset> _logoSlideAnimation;

  @override
  void initState() {
    super.initState();

    _logoAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _logoSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.easeOutBack,
      ),
    );

    _logoAnimationController.forward();
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    _logoAnimationController.dispose();
    super.dispose();
  }

  Future<void> signupUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: emailCtrl.text.trim(), password: passwordCtrl.text.trim());

      final uid = credential.user?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'email': emailCtrl.text.trim(),
          'createdAt': Timestamp.now(),
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created. Please log in.")),
      );

      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = switch (e.code) {
          'email-already-in-use' => "Account already exists.",
          'invalid-email' => "Invalid email format.",
          'weak-password' => "Password is too weak.",
          _ => "Sign-up failed: ${e.message}",
        };
      });
    } catch (e) {
      setState(() => _errorMessage = "An unexpected error occurred.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFE4F2), // 🍓 Light pinkish background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: _logoSlideAnimation,
                child: Image.asset(
                  'assets/images/img.jpg',  // ✅ Use your fruity logo or bottle image
                  height: 140,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Join the Slushies Family!',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: const Color(0xFF4B0082), // Blueberry deep purple/blue
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sip fresh. Stay cool. 🍓❄️',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.email, color: Colors.pinkAccent),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Enter your email';
                        if (!value.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordCtrl,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.lock, color: Colors.pinkAccent),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Enter your password';
                        if (value.length < 6) return 'Password must be at least 6 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    if (_errorMessage != null)
                      Text(_errorMessage!, style: const TextStyle(color: Colors.redAccent)),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : signupUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF001F54), // 🍇 Deep blue button
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Create Account",
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                      child: Text(
                        "Already have an account? Log In",
                        style: TextStyle(color: Colors.blue.shade800),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
