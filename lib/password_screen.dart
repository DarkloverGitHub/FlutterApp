import 'package:flutter/material.dart';

// ════════════════════════════════════════════════════════
//  PASSWORD SCREEN  —  lib/screens/password_screen.dart
//
//  This file handles the full "Forgot Password" flow
//  broken into 3 steps inside ONE screen:
//
//  STEP 1 → Enter email address
//  STEP 2 → Enter 4-digit OTP code
//  STEP 3 → Enter new password + confirm
//
//  No extra packages needed — pure Flutter widgets.
// ════════════════════════════════════════════════════════

// ─────────────────────────────────────────────
//  SHARED COLORS
// ─────────────────────────────────────────────
const kBlue = Color(0xFF3478F6);
const kGrey = Colors.grey;
const kRed  = Color(0xFFE24B4A);

// ════════════════════════════════════════════════════════
//  MAIN WIDGET  —  ForgotPasswordScreen
//
//  StatefulWidget because:
//    • _step tracks which step we are on (1, 2, or 3)
//    • Controllers hold the typed values
//    • _hideNew / _hideConfirm toggle password visibility
// ════════════════════════════════════════════════════════
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // ── Which step is the user on? ──
  // 1 = Email entry
  // 2 = OTP verification
  // 3 = New password entry
  int _step = 1;

  // ── Text controllers ──
  final _emailCtrl   = TextEditingController(); // step 1
  final _newPassCtrl = TextEditingController(); // step 3
  final _confPassCtrl = TextEditingController(); // step 3

  // ── OTP: 4 separate single-character controllers ──
  // Each box holds 1 digit
  final List<TextEditingController> _otpCtrls =
      List.generate(4, (_) => TextEditingController());

  // ── FocusNodes: auto-move cursor between OTP boxes ──
  final List<FocusNode> _otpFocus =
      List.generate(4, (_) => FocusNode());

  // ── Password visibility toggles (step 3) ──
  bool _hideNew     = true;
  bool _hideConfirm = true;

  // ── Error message shown below inputs ──
  String? _errorMsg;

  // ── Always dispose to free memory ──
  @override
  void dispose() {
    _emailCtrl.dispose();
    _newPassCtrl.dispose();
    _confPassCtrl.dispose();
    for (final c in _otpCtrls) c.dispose();
    for (final f in _otpFocus) f.dispose();
    super.dispose();
  }

  // ════════════════════════════════════════════════════
  //  STEP HANDLERS
  // ════════════════════════════════════════════════════

  // ── STEP 1: Validate email → go to OTP ──
  void _submitEmail() {
    setState(() => _errorMsg = null);

    final email = _emailCtrl.text.trim();

    // Simple email check: must contain @ and .
    if (email.isEmpty) {
      setState(() => _errorMsg = 'Please enter your email address.');
      return;
    }
    if (!email.contains('@') || !email.contains('.')) {
      setState(() => _errorMsg = 'Please enter a valid email address.');
      return;
    }

    // In a real app: call API to send OTP to email
    // Here we just move to step 2
    setState(() => _step = 2);
  }

  // ── STEP 2: Validate OTP → go to new password ──
  void _submitOtp() {
    setState(() => _errorMsg = null);

    // Combine all 4 OTP boxes into one string
    final otp = _otpCtrls.map((c) => c.text).join();

    if (otp.length < 4) {
      setState(() => _errorMsg = 'Please enter the complete 4-digit code.');
      return;
    }

    // In a real app: call API to verify OTP
    // Hardcoded demo OTP = "1234"
    if (otp != '1234') {
      setState(() => _errorMsg = 'Incorrect code. Try 1234 for demo.');
      return;
    }

    setState(() => _step = 3);
  }

  // ── STEP 3: Validate new password → done ──
  void _submitNewPassword() {
    setState(() => _errorMsg = null);

    final newPass  = _newPassCtrl.text;
    final confPass = _confPassCtrl.text;

    if (newPass.isEmpty) {
      setState(() => _errorMsg = 'Please enter a new password.');
      return;
    }
    if (newPass.length < 6) {
      setState(() => _errorMsg = 'Password must be at least 6 characters.');
      return;
    }
    if (newPass != confPass) {
      setState(() => _errorMsg = 'Passwords do not match.');
      return;
    }

    // In a real app: call API to update password
    // Here we show a success dialog then go back to Login
    _showSuccessDialog();
  }

  // ── Success dialog after password reset ──
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button to dismiss
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Green checkmark circle
            Container(
              width: 70, height: 70,
              decoration: const BoxDecoration(
                color: Color(0xFFE6F9EF), shape: BoxShape.circle),
              child: const Icon(Icons.check_circle, color: Color(0xFF1D9E75), size: 40),
            ),
            const SizedBox(height: 16),
            const Text('Password Reset!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Your password has been changed successfully.',
              textAlign: TextAlign.center,
              style: TextStyle(color: kGrey, fontSize: 13)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);        // close dialog
                  Navigator.pop(context);        // go back to Login
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kBlue,
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

  // ════════════════════════════════════════════════════
  //  BUILD
  // ════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ── AppBar with back arrow ──
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () {
            // If on step 2 or 3, go back to previous step
            // If on step 1, go back to Login screen
            if (_step > 1) {
              setState(() {
                _step--;
                _errorMsg = null;
              });
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

              // ── Step indicator (dots) ──
              _StepIndicator(currentStep: _step),
              const SizedBox(height: 28),

              // ── Show the correct step ──
              if (_step == 1) _buildStep1(),
              if (_step == 2) _buildStep2(),
              if (_step == 3) _buildStep3(),

              // ── Error message (shown below all inputs) ──
              if (_errorMsg != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.error_outline, color: kRed, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(_errorMsg!,
                        style: const TextStyle(color: kRed, fontSize: 13)),
                    ),
                  ],
                ),
              ],

            ],
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════
  //  STEP 1  —  Email Entry
  // ════════════════════════════════════════════════════
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ── Icon ──
        Container(
          width: 70, height: 70,
          decoration: const BoxDecoration(
            color: Color(0xFFE7EFFE), shape: BoxShape.circle),
          child: const Icon(Icons.lock_outline, color: kBlue, size: 36),
        ),
        const SizedBox(height: 20),

        // ── Title ──
        const Text('Forgot Password?',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text(
          'No worries! Enter your email address and we\'ll send you a reset code.',
          style: TextStyle(color: kGrey, fontSize: 14, height: 1.5)),
        const SizedBox(height: 32),

        // ── Email input ──
        const Text('Email Address',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Enter your email address',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kBlue, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 28),

        // ── Send Code button ──
        _BigButton(label: 'Send Reset Code', onTap: _submitEmail),

      ],
    );
  }

  // ════════════════════════════════════════════════════
  //  STEP 2  —  OTP Verification
  // ════════════════════════════════════════════════════
  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ── Icon ──
        Container(
          width: 70, height: 70,
          decoration: const BoxDecoration(
            color: Color(0xFFE7EFFE), shape: BoxShape.circle),
          child: const Icon(Icons.mark_email_read_outlined, color: kBlue, size: 36),
        ),
        const SizedBox(height: 20),

        // ── Title ──
        const Text('Check Your Email',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        // Show which email the code was sent to
        RichText(
          text: TextSpan(
            style: const TextStyle(color: kGrey, fontSize: 14, height: 1.5),
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

        // ── 4 OTP boxes ──
        // Each box is one digit wide, auto-focus jumps to next box
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (i) => _OtpBox(
            controller: _otpCtrls[i],
            focusNode: _otpFocus[i],
            onChanged: (val) {
              if (val.isNotEmpty && i < 3) {
                // Move focus to next box when a digit is typed
                FocusScope.of(context).requestFocus(_otpFocus[i + 1]);
              }
              if (val.isEmpty && i > 0) {
                // Move focus back when backspace is pressed
                FocusScope.of(context).requestFocus(_otpFocus[i - 1]);
              }
            },
          )),
        ),
        const SizedBox(height: 16),

        // ── Resend link ──
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Didn't receive the code?  ",
                style: TextStyle(color: kGrey, fontSize: 13)),
              GestureDetector(
                onTap: () {
                  // In real app: resend OTP API call
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Code resent!'),
                      duration: Duration(seconds: 2)),
                  );
                },
                child: const Text('Resend',
                  style: TextStyle(color: kBlue, fontWeight: FontWeight.w600,
                    fontSize: 13)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // ── Demo hint ──
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFFFE082)),
          ),
          child: Row(
            children: const [
              Icon(Icons.info_outline, color: Color(0xFFF9A825), size: 18),
              SizedBox(width: 8),
              Text('Demo OTP code: 1234',
                style: TextStyle(fontSize: 13, color: Color(0xFF795548))),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // ── Verify button ──
        _BigButton(label: 'Verify Code', onTap: _submitOtp),

      ],
    );
  }

  // ════════════════════════════════════════════════════
  //  STEP 3  —  New Password
  // ════════════════════════════════════════════════════
  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ── Icon ──
        Container(
          width: 70, height: 70,
          decoration: const BoxDecoration(
            color: Color(0xFFE7EFFE), shape: BoxShape.circle),
          child: const Icon(Icons.lock_reset_outlined, color: kBlue, size: 36),
        ),
        const SizedBox(height: 20),

        // ── Title ──
        const Text('Set New Password',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text(
          'Your new password must be at least 6 characters long.',
          style: TextStyle(color: kGrey, fontSize: 14, height: 1.5)),
        const SizedBox(height: 32),

        // ── New password ──
        const Text('New Password',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: _newPassCtrl,
          obscureText: _hideNew,
          decoration: InputDecoration(
            hintText: 'Enter new password',
            hintStyle: TextStyle(color: Colors.grey.shade400),
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
              borderSide: const BorderSide(color: kBlue, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 18),

        // ── Confirm password ──
        const Text('Confirm Password',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: _confPassCtrl,
          obscureText: _hideConfirm,
          decoration: InputDecoration(
            hintText: 'Re-enter new password',
            hintStyle: TextStyle(color: Colors.grey.shade400),
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
              borderSide: const BorderSide(color: kBlue, width: 2),
            ),
          ),
        ),

        // ── Password strength hints ──
        const SizedBox(height: 14),
        const _PasswordHint(text: 'At least 6 characters'),
        const _PasswordHint(text: 'Use letters and numbers'),
        const _PasswordHint(text: 'Avoid using your name or email'),

        const SizedBox(height: 28),

        // ── Reset button ──
        _BigButton(label: 'Reset Password', onTap: _submitNewPassword),

      ],
    );
  }
}

// ════════════════════════════════════════════════════════
//  REUSABLE WIDGETS  (used inside this file only)
// ════════════════════════════════════════════════════════

// ── Step indicator: 3 dots, active dot is blue ──
class _StepIndicator extends StatelessWidget {
  final int currentStep;
  const _StepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (i) {
        final bool active = i + 1 == currentStep;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(right: 8),
          width: active ? 28 : 10,  // active dot is wider
          height: 10,
          decoration: BoxDecoration(
            color: active ? kBlue : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(5),
          ),
        );
      }),
    );
  }
}

// ── Single OTP digit box ──
class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 64,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,           // digit centered in box
        keyboardType: TextInputType.number,    // show number keyboard
        maxLength: 1,                          // only 1 digit per box
        onChanged: onChanged,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: kBlue,
        ),
        decoration: InputDecoration(
          counterText: '',                     // hide "1/1" counter
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kBlue, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
      ),
    );
  }
}

// ── Password hint row with bullet ──
class _PasswordHint extends StatelessWidget {
  final String text;
  const _PasswordHint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Container(
            width: 6, height: 6,
            decoration: const BoxDecoration(
              color: kGrey, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: kGrey, fontSize: 12)),
        ],
      ),
    );
  }
}

// ── Full-width blue button ──
class _BigButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _BigButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: kBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}