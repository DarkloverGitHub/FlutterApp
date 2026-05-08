import 'package:flutter/material.dart';
import 'home_screen.dart';

// ══════════════════════════════════════════════
//  REGISTER SCREEN
//  File: lib/screens/register_screen.dart
//
//  Widgets used:
//   • Scaffold        → page scaffold with AppBar
//   • AppBar          → top bar with Back button
//   • SingleChildScrollView → scrollable form
//   • Stack           → overlaps camera badge on avatar
//   • Positioned      → places badge at bottom-right
//   • _buildInputRow  → reusable helper for each field
//   • ElevatedButton  → Register button
// ══════════════════════════════════════════════

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // One controller per input field
  final _nameCtrl     = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _passCtrl     = TextEditingController();
  final _confirmCtrl  = TextEditingController();

  // Toggle password visibility independently
  bool _obscurePass    = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    // Always dispose all controllers
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _usernameCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _handleRegister() {
    // pushReplacement → go to Home, clear navigation stack
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  // ── Reusable input row builder ──
  // Instead of copying the same Container 5 times,
  // we make a helper method that takes parameters.
  Widget _buildInputRow({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,         // is this a password field?
    bool showEye = false,         // show toggle icon?
    VoidCallback? onEyeTap,       // what happens when eye is tapped
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          // Leading icon
          Icon(icon, color: Colors.grey.shade400, size: 20),
          const SizedBox(width: 10),
          // Text input (no border — parent Container draws it)
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: InputBorder.none, // remove default border
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          // Eye icon (only for password fields)
          if (showEye)
            IconButton(
              icon: Icon(
                obscure ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey.shade400,
                size: 20,
              ),
              onPressed: onEyeTap,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ── AppBar with Back arrow ──
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () => Navigator.pop(context), // go back to Login
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          children: [
            // ── 1. Avatar circle with camera badge ──
            // Stack lets two widgets sit on top of each other
            Stack(
              children: [
                // Blue circle with person icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDDE9FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 44,
                    color: Color(0xFF3478F6),
                  ),
                ),
                // Camera badge pinned to bottom-right of the Stack
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Icon(Icons.camera_alt, size: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // ── 2. Title & subtitle ──
            const Text(
              'Create Account',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Fill in the details to get started',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 26),

            // ── 3. Input Fields ──
            _buildInputRow(
              controller: _nameCtrl,
              hint: 'Full Name',
              icon: Icons.person_outline,
            ),
            _buildInputRow(
              controller: _emailCtrl,
              hint: 'Email',
              icon: Icons.email_outlined,
            ),
            _buildInputRow(
              controller: _usernameCtrl,
              hint: 'Username',
              icon: Icons.alternate_email,
            ),
            _buildInputRow(
              controller: _passCtrl,
              hint: 'Password',
              icon: Icons.lock_outline,
              obscure: _obscurePass,
              showEye: true,
              onEyeTap: () => setState(() => _obscurePass = !_obscurePass),
            ),
            _buildInputRow(
              controller: _confirmCtrl,
              hint: 'Confirm Password',
              icon: Icons.lock_outline,
              obscure: _obscureConfirm,
              showEye: true,
              onEyeTap: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
            ),
            const SizedBox(height: 8),

            // ── 4. Register Button ──
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3478F6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Register',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // ── 5. Already have account link ──
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account? ',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context), // back to Login
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Color(0xFF3478F6),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}