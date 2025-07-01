import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _emailController = TextEditingController(text: "admin@slushies.com");
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE4F2), // Same pink shade as HomePage
      appBar: AppBar(
        backgroundColor: const Color(0xFF001F54), // Deep blue like HomePage
        iconTheme: const IconThemeData(color: Colors.white), // White back arrow
        title: const Text(
          "Your Profile",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Profile Image
            const CircleAvatar(
              radius: 55,
              backgroundImage: AssetImage('assets/images/user.jpg'), // Your custom admin photo here
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(height: 12),

            // Username Text
            const Text(
              "User",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4B0082), // Deep purple text (matches drinks title color)
              ),
            ),
            const SizedBox(height: 28),

            // Editable Info Card
            Card(
              color: Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email, color: Color.fromARGB(255, 173, 113, 173)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: "New Password",
                        prefixIcon: const Icon(Icons.lock, color: Color.fromARGB(255, 173, 113, 173)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.pinkAccent,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Profile updated successfully!")),
                        );
                      },
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text("Save Changes"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 34, 177, 29),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Go to Home Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
              },
              icon: const Icon(Icons.home, color: Colors.white),
              label: const Text("Go to Home"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF001F54), // Deep blue
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
              ),
            ),
            const SizedBox(height: 10),

            // Log Out Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
              },
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text("Log Out"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
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
