import 'package:first_class/localstorage.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const WalletApp(),
    ),
  );
}

// ════════════════════════════════════════════════════════
//  ROOT APP
// ════════════════════════════════════════════════════════
class WalletApp extends StatelessWidget {
  const WalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallet App',
      debugShowCheckedModeBanner: false,
      // ── DevicePreview required lines ──
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3478F6)),
        useMaterial3: true,
        fontFamily: 'Roboto',
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
      home: const Localstorage(),
    );
  }
}

// ════════════════════════════════════════════════════════
//  SCREEN 1 — LOGIN SCREEN
// ════════════════════════════════════════════════════════
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  // ✅ FIXED: Opens ForgotPasswordScreen
  void _handleForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
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
            children: [
              // ── Avatar ──
              Container(
                width: 90, height: 90,
                decoration: const BoxDecoration(
                  color: Color(0xFF3478F6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 20),

              const Text('Login',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text('Please enter your credentials to login',
                  style: TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 36),

              // ── Username ──
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: const TextStyle(color: Color(0xFF3478F6)),
                  hintText: 'Enter your username',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF3478F6), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

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
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF3478F6), width: 2),
                  ),
                ),
              ),

              // ✅ FIXED: ONE forgot password button that actually navigates
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _handleForgotPassword, // ← was () {}, now works!
                  child: const Text('Forgot password?',
                      style: TextStyle(color: Color(0xFF3478F6))),
                ),
              ),
              const SizedBox(height: 8),

              // ── Submit ──
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3478F6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Submit',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 20),

              // ── Register ──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No account? ', style: TextStyle(color: Colors.grey)),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const RegisterScreen())),
                    child: const Text('Register',
                        style: TextStyle(
                            color: Color(0xFF3478F6), fontWeight: FontWeight.w600)),
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

// ════════════════════════════════════════════════════════
//  SCREEN 2 — FORGOT PASSWORD SCREEN  (3-step flow)
//  Step 1 → Enter email
//  Step 2 → Enter OTP (demo code: 1234)
//  Step 3 → Set new password
// ════════════════════════════════════════════════════════
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  int _step = 1; // 1=Email, 2=OTP, 3=NewPassword

  final _emailCtrl    = TextEditingController();
  final _newPassCtrl  = TextEditingController();
  final _confPassCtrl = TextEditingController();

  // 4 OTP boxes
  final List<TextEditingController> _otpCtrls =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _otpFocus =
      List.generate(4, (_) => FocusNode());

  bool _hideNew     = true;
  bool _hideConfirm = true;
  String? _errorMsg;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _newPassCtrl.dispose();
    _confPassCtrl.dispose();
    for (final c in _otpCtrls) c.dispose();
    for (final f in _otpFocus) f.dispose();
    super.dispose();
  }

  // ── Step 1: validate email ──
  void _submitEmail() {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      setState(() => _errorMsg = 'Please enter a valid email address.');
      return;
    }
    setState(() { _errorMsg = null; _step = 2; });
  }

  // ── Step 2: validate OTP ──
  void _submitOtp() {
    final otp = _otpCtrls.map((c) => c.text).join();
    if (otp.length < 4) {
      setState(() => _errorMsg = 'Please enter the complete 4-digit code.');
      return;
    }
    if (otp != '1234') {
      setState(() => _errorMsg = 'Incorrect code. Use 1234 for demo.');
      return;
    }
    setState(() { _errorMsg = null; _step = 3; });
  }

  // ── Step 3: validate new password ──
  void _submitNewPassword() {
    final newPass  = _newPassCtrl.text;
    final confPass = _confPassCtrl.text;
    if (newPass.length < 6) {
      setState(() => _errorMsg = 'Password must be at least 6 characters.');
      return;
    }
    if (newPass != confPass) {
      setState(() => _errorMsg = 'Passwords do not match.');
      return;
    }
    setState(() => _errorMsg = null);
    _showSuccess();
  }

  void _showSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70, height: 70,
              decoration: const BoxDecoration(
                  color: Color(0xFFE6F9EF), shape: BoxShape.circle),
              child: const Icon(Icons.check_circle,
                  color: Color(0xFF1D9E75), size: 40),
            ),
            const SizedBox(height: 16),
            const Text('Password Reset!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Your password has been changed successfully.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  Navigator.pop(context); // back to Login
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3478F6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Back to Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () {
            if (_step > 1) {
              setState(() { _step--; _errorMsg = null; });
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Step dots ──
              Row(
                children: List.generate(3, (i) {
                  final bool active = i + 1 == _step;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(right: 8),
                    width: active ? 28 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: active
                          ? const Color(0xFF3478F6)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 28),

              if (_step == 1) _buildStep1(),
              if (_step == 2) _buildStep2(),
              if (_step == 3) _buildStep3(),

              // ── Error message ──
              if (_errorMsg != null) ...[
                const SizedBox(height: 12),
                Row(children: [
                  const Icon(Icons.error_outline, color: Color(0xFFE24B4A), size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(_errorMsg!,
                        style: const TextStyle(
                            color: Color(0xFFE24B4A), fontSize: 13)),
                  ),
                ]),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ── STEP 1: Email ──
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 70, height: 70,
          decoration: const BoxDecoration(
              color: Color(0xFFE7EFFE), shape: BoxShape.circle),
          child: const Icon(Icons.lock_outline,
              color: Color(0xFF3478F6), size: 36),
        ),
        const SizedBox(height: 20),
        const Text('Forgot Password?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text(
            'Enter your email address and we\'ll send you a reset code.',
            style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5)),
        const SizedBox(height: 32),
        const Text('Email Address',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Enter your email address',
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3478F6), width: 2),
            ),
          ),
        ),
        const SizedBox(height: 28),
        _bigButton('Send Reset Code', _submitEmail),
      ],
    );
  }

  // ── STEP 2: OTP ──
  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 70, height: 70,
          decoration: const BoxDecoration(
              color: Color(0xFFE7EFFE), shape: BoxShape.circle),
          child: const Icon(Icons.mark_email_read_outlined,
              color: Color(0xFF3478F6), size: 36),
        ),
        const SizedBox(height: 20),
        const Text('Check Your Email',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
            children: [
              const TextSpan(text: 'We sent a 4-digit code to\n'),
              TextSpan(
                text: _emailCtrl.text.trim(),
                style: const TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        const Text('Enter OTP Code',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),

        // 4 OTP boxes
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (i) {
            return SizedBox(
              width: 60, height: 64,
              child: TextField(
                controller: _otpCtrls[i],
                focusNode: _otpFocus[i],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                onChanged: (val) {
                  if (val.isNotEmpty && i < 3) {
                    FocusScope.of(context).requestFocus(_otpFocus[i + 1]);
                  }
                  if (val.isEmpty && i > 0) {
                    FocusScope.of(context).requestFocus(_otpFocus[i - 1]);
                  }
                },
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3478F6)),
                decoration: InputDecoration(
                  counterText: '',
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF3478F6), width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 14),

        // Resend link
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Didn't receive the code?  ",
                  style: TextStyle(color: Colors.grey, fontSize: 13)),
              GestureDetector(
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Code resent!'),
                      duration: Duration(seconds: 2)),
                ),
                child: const Text('Resend',
                    style: TextStyle(
                        color: Color(0xFF3478F6),
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Demo hint box
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFFFE082)),
          ),
          child: Row(children: const [
            Icon(Icons.info_outline, color: Color(0xFFF9A825), size: 18),
            SizedBox(width: 8),
            Text('Demo OTP code: 1234',
                style: TextStyle(fontSize: 13, color: Color(0xFF795548))),
          ]),
        ),
        const SizedBox(height: 28),
        _bigButton('Verify Code', _submitOtp),
      ],
    );
  }

  // ── STEP 3: New Password ──
  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 70, height: 70,
          decoration: const BoxDecoration(
              color: Color(0xFFE7EFFE), shape: BoxShape.circle),
          child: const Icon(Icons.lock_reset_outlined,
              color: Color(0xFF3478F6), size: 36),
        ),
        const SizedBox(height: 20),
        const Text('Set New Password',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Your new password must be at least 6 characters.',
            style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5)),
        const SizedBox(height: 32),

        // New password
        const Text('New Password',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: _newPassCtrl,
          obscureText: _hideNew,
          decoration: InputDecoration(
            hintText: 'Enter new password',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                  _hideNew ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey),
              onPressed: () => setState(() => _hideNew = !_hideNew),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3478F6), width: 2),
            ),
          ),
        ),
        const SizedBox(height: 18),

        // Confirm password
        const Text('Confirm Password',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: _confPassCtrl,
          obscureText: _hideConfirm,
          decoration: InputDecoration(
            hintText: 'Re-enter new password',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                  _hideConfirm ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey),
              onPressed: () => setState(() => _hideConfirm = !_hideConfirm),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3478F6), width: 2),
            ),
          ),
        ),
        const SizedBox(height: 28),
        _bigButton('Reset Password', _submitNewPassword),
      ],
    );
  }

  // ── Reusable full-width button ──
  Widget _bigButton(String label, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3478F6),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
//  SCREEN 3 — REGISTER SCREEN
// ════════════════════════════════════════════════════════
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController     = TextEditingController();
  final _emailController    = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController  = TextEditingController();
  bool _obscurePass    = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    VoidCallback? onToggle,
    bool showToggle = false,
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
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          if (showToggle)
            IconButton(
              icon: Icon(
                obscure ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey, size: 20,
              ),
              onPressed: onToggle,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black54),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 80, height: 80,
                  decoration: const BoxDecoration(
                      color: Color(0xFFDDE9FF), shape: BoxShape.circle),
                  child: const Icon(Icons.person, size: 44, color: Color(0xFF3478F6)),
                ),
                Positioned(
                  bottom: 0, right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Icon(Icons.camera_alt, size: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Create Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Fill in the details to get started',
                style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 24),
            _buildInput(controller: _nameController,     hint: 'Full Name',        icon: Icons.person_outline),
            _buildInput(controller: _emailController,    hint: 'Email',            icon: Icons.email_outlined),
            _buildInput(controller: _usernameController, hint: 'Username',         icon: Icons.alternate_email),
            _buildInput(
              controller: _passwordController, hint: 'Password',
              icon: Icons.lock_outline, obscure: _obscurePass, showToggle: true,
              onToggle: () => setState(() => _obscurePass = !_obscurePass),
            ),
            _buildInput(
              controller: _confirmController, hint: 'Confirm Password',
              icon: Icons.lock_outline, obscure: _obscureConfirm, showToggle: true,
              onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity, height: 54,
              child: ElevatedButton(
                onPressed: _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3478F6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Register',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account? ',
                    style: TextStyle(color: Colors.grey, fontSize: 14)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text('Login',
                      style: TextStyle(color: Color(0xFF3478F6), fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
//  SCREEN 4 — HOME SCREEN
// ════════════════════════════════════════════════════════
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const _HomeTab(),
    const _TransactionsTab(),
    const SizedBox(),
    const _CardsTab(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF3478F6),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(icon: Icons.home_outlined,          activeIcon: Icons.home,         label: 'Home',         index: 0, current: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
            _NavItem(icon: Icons.receipt_long_outlined,  activeIcon: Icons.receipt_long, label: 'Transactions', index: 1, current: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
            const SizedBox(width: 48),
            _NavItem(icon: Icons.credit_card_outlined,   activeIcon: Icons.credit_card,  label: 'Cards',        index: 3, current: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
            _NavItem(icon: Icons.person_outline,         activeIcon: Icons.person,        label: 'Profile',      index: 4, current: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon, activeIcon;
  final String label;
  final int index, current;
  final ValueChanged<int> onTap;
  const _NavItem({required this.icon, required this.activeIcon, required this.label,
      required this.index, required this.current, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final bool isActive = index == current;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(isActive ? activeIcon : icon,
            color: isActive ? const Color(0xFF3478F6) : Colors.grey),
        Text(label,
            style: TextStyle(fontSize: 11,
                color: isActive ? const Color(0xFF3478F6) : Colors.grey)),
      ]),
    );
  }
}

// ── Home Tab ──
class _HomeTab extends StatelessWidget {
  const _HomeTab();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                  Text('Hi, Sudhir! 👋',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text('Welcome back', style: TextStyle(color: Colors.grey)),
                ]),
                const Icon(Icons.notifications_outlined, size: 28),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3478F6), Color(0xFF2255D0)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Wallet Balance', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 8),
                    const Text('\$1,250.00',
                        style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(children: const [
                      Text('View Details', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right, color: Colors.white70, size: 16),
                    ]),
                  ])),
                  const Icon(Icons.account_balance_wallet, size: 52, color: Colors.white24),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Quick Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _QuickAction(icon: Icons.send,               label: 'Send',    color: const Color(0xFFE7EFFE), iconColor: const Color(0xFF3478F6)),
                _QuickAction(icon: Icons.download,           label: 'Receive', color: const Color(0xFFE6F9EF), iconColor: const Color(0xFF1D9E75)),
                _QuickAction(icon: Icons.add_circle_outline, label: 'Top Up',  color: const Color(0xFFF2E9FF), iconColor: const Color(0xFF8B5CF6)),
                _QuickAction(icon: Icons.more_horiz,         label: 'More',    color: const Color(0xFFF0F0F0), iconColor: Colors.grey),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recent Transactions',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                TextButton(
                  onPressed: () {},
                  child: const Text('See All', style: TextStyle(color: Color(0xFF3478F6), fontSize: 13)),
                ),
              ],
            ),
            _TransactionItem(logo: 'A', logoColor: Colors.orange,        name: 'Amazon',    category: 'Shopping',     amount: '-\$60.00',    date: 'May 12', isDebit: true),
            _TransactionItem(logo: 'S', logoColor: const Color(0xFF00704A), name: 'Starbucks', category: 'Food & Drink', amount: '-\$5.25',    date: 'May 12', isDebit: true),
            _TransactionItem(logo: '\$', logoColor: Colors.green,         name: 'Salary',    category: 'Income',       amount: '+\$1,500.00', date: 'May 10', isDebit: false),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon; final String label; final Color color, iconColor;
  const _QuickAction({required this.icon, required this.label, required this.color, required this.iconColor});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: 56, height: 56,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
        child: Icon(icon, color: iconColor, size: 26),
      ),
      const SizedBox(height: 6),
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
    ]);
  }
}

class _TransactionItem extends StatelessWidget {
  final String logo, name, category, amount, date;
  final Color logoColor;
  final bool isDebit;
  const _TransactionItem({required this.logo, required this.logoColor, required this.name,
      required this.category, required this.amount, required this.date, required this.isDebit});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        CircleAvatar(radius: 22, backgroundColor: logoColor,
            child: Text(logo, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          Text(category, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(amount, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14,
              color: isDebit ? const Color(0xFFE24B4A) : const Color(0xFF1D9E75))),
          Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ]),
      ]),
    );
  }
}

class _TransactionsTab extends StatelessWidget {
  const _TransactionsTab();
  @override
  Widget build(BuildContext context) => const SafeArea(
      child: Center(child: Text('All Transactions', style: TextStyle(fontSize: 18, color: Colors.grey))));
}

class _CardsTab extends StatelessWidget {
  const _CardsTab();
  @override
  Widget build(BuildContext context) => const SafeArea(
      child: Center(child: Text('My Cards', style: TextStyle(fontSize: 18, color: Colors.grey))));
}

// ════════════════════════════════════════════════════════
//  SCREEN 5 — PROFILE SCREEN
// ════════════════════════════════════════════════════════
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Icon(Icons.settings_outlined, size: 24),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              Stack(children: [
                const CircleAvatar(
                  radius: 44,
                  backgroundColor: Color(0xFFC0D4F5),
                  child: Text('SY',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF3478F6))),
                ),
                Positioned(bottom: 2, right: 2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3478F6), shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.edit, size: 12, color: Colors.white),
                  ),
                ),
              ]),
              const SizedBox(height: 12),
              const Text('Sudhir Yadav',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('Sudhiryadav@email.com',
                  style: TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 28),
              _ProfileMenuItem(icon: Icons.person_outline,         label: 'Personal Information'),
              _ProfileMenuItem(icon: Icons.settings_outlined,      label: 'Account Settings'),
              _ProfileMenuItem(icon: Icons.shield_outlined,        label: 'Security'),
              _ProfileMenuItem(icon: Icons.notifications_outlined, label: 'Notifications'),
              _ProfileMenuItem(icon: Icons.help_outline,           label: 'Help & Support'),
              _ProfileMenuItem(
                icon: Icons.logout,
                label: 'Logout',
                labelColor: const Color(0xFFE24B4A),
                onTap: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? labelColor;
  final VoidCallback? onTap;
  const _ProfileMenuItem({required this.icon, required this.label, this.labelColor, this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(children: [
          Icon(icon, size: 22, color: labelColor ?? Colors.grey),
          const SizedBox(width: 16),
          Expanded(child: Text(label,
              style: TextStyle(fontSize: 15,
                  color: labelColor ?? Theme.of(context).colorScheme.onSurface))),
          Icon(Icons.chevron_right, color: Colors.grey.shade300),
        ]),
      ),
    );
  }
}