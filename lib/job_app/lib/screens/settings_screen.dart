import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback onLogout;
  const SettingsScreen({super.key, required this.onLogout});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifications = true;
  bool _location = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final dark = await StorageService.getDarkMode();
    final notif = await StorageService.getNotifications();
    final loc = await StorageService.getLocation();
    setState(() {
      _darkMode = dark;
      _notifications = notif;
      _location = loc;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 28),

            _SectionHeader('Preferences'),
            const SizedBox(height: 10),
            _SettingsTile(
              icon: Icons.dark_mode_rounded,
              iconColor: Colors.indigo,
              title: 'Dark Mode',
              subtitle: 'Switch to dark theme',
              trailing: Switch.adaptive(
                value: _darkMode,
                activeColor: AppTheme.primary,
                onChanged: (v) async {
                  setState(() => _darkMode = v);
                  await StorageService.setDarkMode(v);
                },
              ),
            ),
            const SizedBox(height: 10),
            _SettingsTile(
              icon: Icons.notifications_rounded,
              iconColor: Colors.orange,
              title: 'Notifications',
              subtitle: 'Job alerts & updates',
              trailing: Switch.adaptive(
                value: _notifications,
                activeColor: AppTheme.primary,
                onChanged: (v) async {
                  setState(() => _notifications = v);
                  await StorageService.setNotifications(v);
                },
              ),
            ),
            const SizedBox(height: 10),
            _SettingsTile(
              icon: Icons.location_on_rounded,
              iconColor: Colors.green,
              title: 'Location',
              subtitle: 'Find nearby jobs',
              trailing: Switch.adaptive(
                value: _location,
                activeColor: AppTheme.primary,
                onChanged: (v) async {
                  setState(() => _location = v);
                  await StorageService.setLocation(v);
                },
              ),
            ),

            const SizedBox(height: 24),
            _SectionHeader('Account'),
            const SizedBox(height: 10),
            _SettingsTile(
              icon: Icons.lock_rounded,
              iconColor: Colors.teal,
              title: 'Change Password',
              subtitle: 'Update your password',
              trailing: const Icon(Icons.chevron_right_rounded,
                  color: AppTheme.textGrey),
              onTap: () {},
            ),
            const SizedBox(height: 10),
            _SettingsTile(
              icon: Icons.privacy_tip_rounded,
              iconColor: Colors.blue,
              title: 'Privacy Policy',
              subtitle: 'Read our privacy policy',
              trailing: const Icon(Icons.chevron_right_rounded,
                  color: AppTheme.textGrey),
              onTap: () {},
            ),
            const SizedBox(height: 10),
            _SettingsTile(
              icon: Icons.help_rounded,
              iconColor: Colors.purple,
              title: 'Help & Support',
              subtitle: 'Get help from our team',
              trailing: const Icon(Icons.chevron_right_rounded,
                  color: AppTheme.textGrey),
              onTap: () {},
            ),

            const SizedBox(height: 32),
            // Logout button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () => _showLogoutDialog(context),
                icon: const Icon(Icons.logout_rounded, color: Colors.red),
                label: const Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'DreamJob v1.0.0',
                style: TextStyle(color: AppTheme.textGrey, fontSize: 12),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Log Out',
            style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: AppTheme.textGrey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.onLogout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppTheme.textGrey,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                        fontSize: 12, color: AppTheme.textGrey),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
