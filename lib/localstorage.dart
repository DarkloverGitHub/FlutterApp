import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'locallogin.dart'; // ✅ Navigate to Login after Register

// ════════════════════════════════════════════════════════
//  LOCALSTORAGE.DART  —  Register Screen
//
//  FIXES APPLIED:
//  1. Changed StatelessWidget → StatefulWidget
//     WHY: Controllers & async functions must live in State,
//          not inside build(). In StatelessWidget, build()
//          runs many times — creating new controllers each time
//          causes memory leaks and bugs.
//
//  2. Moved controllers to State class (initState/dispose)
//     WHY: Controllers need dispose() to free memory.
//          Inside build() they can never be disposed properly.
//
//  3. Fixed navigation after register:
//     Was:  Navigator.push → Localstorage()  (loops back to register!)
//     Fix:  Navigator.pushReplacement → Localstoragelogin()
//
//  4. Added password obscureText + basic validation
//  5. Added proper padding and styling
// ════════════════════════════════════════════════════════

class Localstorage extends StatefulWidget {  // ✅ StatefulWidget not Stateless
  const Localstorage({super.key});

  @override
  State<Localstorage> createState() => _LocalstorageState();
}

class _LocalstorageState extends State<Localstorage> {

  // ✅ Controllers declared here — NOT inside build()
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true; // toggle password visibility
  bool _isLoading = false;      // show loading on button while saving

  // ✅ dispose() frees memory when screen is removed
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Save username & password to SharedPreferences ──
  Future<void> _onRegister() async {
    // Basic validation — don't save empty fields
    if (_usernameController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true); // show loading

    final pref = await SharedPreferences.getInstance();

    // Save to local storage
    await pref.setString('username', _usernameController.text.trim());
    await pref.setString('password', _passwordController.text.trim());

    setState(() => _isLoading = false); // hide loading

    if (!mounted) return; // safety check after async gap

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registered Successfully! Please login.'),
        backgroundColor: Colors.green,
      ),
    );

    // ✅ FIXED: Go to Login screen, not back to Register
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Localstoragelogin()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // ── Icon ──
              const Icon(Icons.person_add_outlined,
                  size: 72, color: Color(0xFF3478F6)),
              const SizedBox(height: 16),

              // ── Title ──
              const Text('Register',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text('Create your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 36),

              // ── Username field ──
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: const TextStyle(color: Color(0xFF3478F6)),
                  hintText: 'Enter a username',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF3478F6), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Password field ──
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword, // hides text as dots
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Color(0xFF3478F6)),
                  hintText: 'Enter a password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  // Eye icon to show/hide password
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF3478F6), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // ── Register Button ──
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  // Show spinner while saving, otherwise show label
                  onPressed: _isLoading ? null : _onRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3478F6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22, height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5))
                      : const Text('Register',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 20),

              // ── Already have account link ──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?  ',
                      style: TextStyle(color: Colors.grey)),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const Localstoragelogin()),
                    ),
                    child: const Text('Login',
                        style: TextStyle(
                            color: Color(0xFF3478F6),
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}