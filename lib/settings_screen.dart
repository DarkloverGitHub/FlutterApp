import 'package:flutter/material.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _biometrics = false;
  String _selectedLanguage = 'English';

  final List<String> _languages = [
    'English',
    'Nepali',
    'Hindi',
    'Spanish',
    'French',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C63FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Notifications Section ──────────────────────────
            _sectionTitle("Notifications"),
            _settingsCard(
              children: [
                _switchTile(
                  icon: Icons.notifications_outlined,
                  label: "Push Notifications",
                  value: _pushNotifications,
                  onChanged: (val) =>
                      setState(() => _pushNotifications = val),
                ),
                _divider(),
                _switchTile(
                  icon: Icons.email_outlined,
                  label: "Email Notifications",
                  value: _emailNotifications,
                  onChanged: (val) =>
                      setState(() => _emailNotifications = val),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Security Section ───────────────────────────────
            _sectionTitle("Security"),
            _settingsCard(
              children: [
                _switchTile(
                  icon: Icons.fingerprint,
                  label: "Biometric Login",
                  value: _biometrics,
                  onChanged: (val) =>
                      setState(() => _biometrics = val),
                ),
                _divider(),
                _tappableTile(
                  icon: Icons.lock_outline,
                  label: "Change Password",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Change password tapped'),
                          backgroundColor: Color(0xFF6C63FF)),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Preferences Section ────────────────────────────
            _sectionTitle("Preferences"),
            _settingsCard(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.language,
                          size: 20, color: Color(0xFF555555)),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Text(
                          "Language",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF222222),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedLanguage,
                          style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6C63FF),
                              fontWeight: FontWeight.w500),
                          icon: const Icon(Icons.keyboard_arrow_down,
                              color: Color(0xFF6C63FF), size: 18),
                          items: _languages
                              .map((lang) => DropdownMenuItem(
                                    value: lang,
                                    child: Text(lang),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(
                                  () => _selectedLanguage = val);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                _divider(),
                _tappableTile(
                  icon: Icons.info_outline,
                  label: "About App",
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'Shoppy',
                      applicationVersion: '1.0.0',
                      applicationLegalese: '© 2026 Shoppy',
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Account Section ────────────────────────────────
            _sectionTitle("Account"),
            _settingsCard(
              children: [
                _tappableTile(
                  icon: Icons.delete_outline,
                  label: "Delete Account",
                  textColor: Colors.red,
                  iconColor: Colors.red,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Delete Account"),
                        content: const Text(
                            "Are you sure you want to delete your account? This action cannot be undone."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Account deleted'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                            child: const Text("Delete",
                                style:
                                    TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                _divider(),
                _tappableTile(
                  icon: Icons.logout,
                  label: "Logout",
                  textColor: const Color(0xFF6C63FF),
                  iconColor: const Color(0xFF6C63FF),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF9E9E9E),
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _settingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _switchTile({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF555555)),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF222222),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF6C63FF),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFCCCCCC),
            trackOutlineColor:
                WidgetStateProperty.all(Colors.transparent),
          ),
        ],
      ),
    );
  }

  Widget _tappableTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon,
                size: 20,
                color: iconColor ?? const Color(0xFF555555)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor ?? const Color(0xFF222222),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.chevron_right,
                size: 18,
                color: (textColor ?? const Color(0xFF555555))
                    .withOpacity(0.5)),
          ],
        ),
      ),
    );
  }

  Widget _divider() => const Divider(
        height: 1,
        thickness: 1,
        indent: 50,
        endIndent: 0,
        color: Color(0xFFF0F0F0),
      );
}