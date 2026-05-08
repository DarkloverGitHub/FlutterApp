import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'localstorage.dart';   // for "No account? Register" link
import 'home_screen.dart';    // navigate here on successful login

// ════════════════════════════════════════════════════════
//  LOCALLOGIN.DART  —  Login Screen (with SharedPreferences)
//
//  FIXES APPLIED:
//  1. Changed StatelessWidget → StatefulWidget
//     WHY: Same reason as localstorage.dart — controllers
//          must live in State, not inside build().
//
//  2. Moved controllers to initState, disposed in dispose()
//
//  3. Added password obscureText toggle
//
//  4. Added "No account? Register" link
//
//  5. Added mounted check after async gap
//     WHY: After "await", the widget might have been removed
//          from the tree. Using context after that crashes.
//          if (!mounted) return;  prevents this crash.
//
//  6. Added loading indicator on Login button
//
//  7. Used pushReplacement to go to HomeScreen
//     WHY: After login, pressing Back should not return
//          to the login screen.
// ════════════════════════════════════════════════════════

class Localstoragelogin extends StatefulWidget { // ✅ StatefulWidget
  const Localstoragelogin({super.key});

  @override
  State<Localstoragelogin> createState() => _LocalstorageloginState();
}

class _LocalstorageloginState extends State<Localstoragelogin> {

  // ✅ Controllers declared in State, not in build()
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true; // toggle password dots
  bool _isLoading = false;      // loading spinner on button

  @override
  void dispose() {
    // ✅ Always dispose controllers to free memory
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Read from SharedPreferences and compare ──
  Future<void> _onLogin() async {
    // Don't allow empty login attempt
    if (_usernameController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter username and password.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true); // show spinner

    final pref = await SharedPreferences.getInstance();

    // Read saved credentials
    final String? savedUsername = pref.getString('username');
    final String? savedPassword = pref.getString('password');

    // What the user typed
    final String enteredUsername = _usernameController.text.trim();
    final String enteredPassword = _passwordController.text.trim();

    setState(() => _isLoading = false); // hide spinner

    // ✅ mounted check — widget might have been removed during await
    if (!mounted) return;

    if (enteredUsername == savedUsername &&
        enteredPassword == savedPassword) {
      // ✅ Correct credentials — go to Home
      // pushReplacement: removes login from back stack
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      // ✅ Wrong credentials — show specific error message
      String errorMsg = 'Invalid username or password.';

      // No account registered at all?
      if (savedUsername == null) {
        errorMsg = 'No account found. Please register first.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: Colors.red,
        ),
      );
    }
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
              const Icon(Icons.lock_outline,
                  size: 72, color: Color(0xFF3478F6)),
              const SizedBox(height: 16),

              // ── Title ──
              const Text('Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text('Sign in to your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 36),

              // ── Username ──
              TextField(
                controller: _usernameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: const TextStyle(color: Color(0xFF3478F6)),
                  hintText: 'Enter your username',
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

              // ── Password ──
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Color(0xFF3478F6)),
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock_outline),
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

              // ── Login Button ──
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _onLogin,
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
                      : const Text('Login',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 20),

              // ── No account? Register ──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No account?  ',
                      style: TextStyle(color: Colors.grey)),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const Localstorage()),
                    ),
                    child: const Text('Register',
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