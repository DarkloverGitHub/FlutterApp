import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    await StorageService.saveUser(
      email: _emailCtrl.text.trim(),
      name: _emailCtrl.text.split('@').first,
    );
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF0EC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 36),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Title ────────────────────────────────────────────
                    const Text(
                      'Create Account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Create an account so you can explore all\nthe existing jobs',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.textGrey,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 36),

                    // ── Email (active/focused style – orange border) ──────
                    _buildField(
                      controller: _emailCtrl,
                      hint: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      autofocus: true,
                      validator: (v) =>
                          v == null || !v.contains('@')
                              ? 'Enter a valid email'
                              : null,
                    ),

                    const SizedBox(height: 16),

                    // ── Password ─────────────────────────────────────────
                    _buildField(
                      controller: _passCtrl,
                      hint: 'Password',
                      obscure: _obscure,
                      filled: false, // light grey like mockup
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppTheme.textGrey,
                          size: 20,
                        ),
                        onPressed: () =>
                            setState(() => _obscure = !_obscure),
                      ),
                      validator: (v) =>
                          v == null || v.length < 6
                              ? 'Min 6 characters'
                              : null,
                    ),

                    const SizedBox(height: 16),

                    // ── Confirm Password ─────────────────────────────────
                    _buildField(
                      controller: _confirmCtrl,
                      hint: 'Confirm Password',
                      obscure: _obscure,
                      filled: false,
                      validator: (v) =>
                          v != _passCtrl.text
                              ? 'Passwords do not match'
                              : null,
                    ),

                    const SizedBox(height: 32),

                    // ── Sign up button ───────────────────────────────────
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: _loading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text('Sign up'),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ── Already have account ─────────────────────────────
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        'Already have an account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.textDark,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Divider ──────────────────────────────────────────
                    Row(
                      children: const [
                        Expanded(
                            child: Divider(
                                color: AppTheme.border, thickness: 1)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Expanded(
                            child: Divider(
                                color: AppTheme.border, thickness: 1)),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ── Social buttons ───────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _SocialBtn(
                            assetPath: 'assets/images/google.svg',
                            isSvg: true),
                        const SizedBox(width: 16),
                        _SocialBtn(
                            assetPath: 'assets/images/facebook.svg',
                            isSvg: true),
                        const SizedBox(width: 16),
                        const _SocialBtn(
                            icon: Icons.apple, isSvg: false),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    bool filled = true,
    bool autofocus = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      autofocus: autofocus,
      validator: validator,
      style: const TextStyle(fontSize: 15, color: AppTheme.textDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            const TextStyle(color: AppTheme.textGrey, fontSize: 15),
        filled: true,
        fillColor:
            filled ? AppTheme.primaryLight : const Color(0xFFF5F5F5),
        suffixIcon: suffixIcon,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: AppTheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}

// ── Shared social button ─────────────────────────────────────────────────────

class _SocialBtn extends StatelessWidget {
  final String? assetPath;
  final IconData? icon;
  final bool isSvg;

  const _SocialBtn({this.assetPath, this.icon, required this.isSvg});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: isSvg && assetPath != null
            ? SvgPicture.asset(assetPath!, width: 24, height: 24)
            : Icon(icon, size: 24, color: Colors.black),
      ),
    );
  }
}
