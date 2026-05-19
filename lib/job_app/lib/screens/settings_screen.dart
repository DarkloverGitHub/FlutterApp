import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ════════════════════════════════════════════════════════
//  SETTINGS SCREEN  —  lib/screens/settings_screen.dart
//
//  FIX: Added onLogout callback parameter
//  home_screen.dart calls:
//    SettingsScreen(onLogout: () { ... })
//  This screen calls onLogout() when user confirms logout
//  so home_screen can navigate to the login screen.
// ════════════════════════════════════════════════════════

class SettingsScreen extends StatefulWidget {
  // ✅ FIX: Added optional onLogout callback
  // home_screen.dart passes: SettingsScreen(onLogout: () { ... })
  final VoidCallback? onLogout;

  const SettingsScreen({super.key, this.onLogout}); // ← was const SettingsScreen({super.key})

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  // ── Toggle states ──
  bool _darkMode      = true;
  bool _notifications = true;
  bool _biometric     = false;

  // ── Picker values ──
  String    _language = 'English';
  DateTime  _date     = DateTime(2024, 5, 25);
  TimeOfDay _time     = const TimeOfDay(hour: 10, minute: 30);

  final List<String> _languages = [
    'English', 'Spanish', 'French', 'German', 'Nepali'
  ];

  String get _formattedDate {
    const months = ['Jan','Feb','Mar','Apr','May','Jun',
                    'Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${_date.day} ${months[_date.month - 1]} ${_date.year}';
  }

  String get _formattedTime => _time.format(context);

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF4F46E5))),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF4F46E5))),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _time = picked);
  }

  void _pickLanguage() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2))),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Select Language',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          ..._languages.map((lang) => ListTile(
            title: Text(lang),
            trailing: lang == _language
                ? const Icon(Icons.check, color: Color(0xFF4F46E5)) : null,
            onTap: () { setState(() => _language = lang); Navigator.pop(ctx); },
          )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ── Logout with confirmation dialog ──
  // ✅ FIX: After logout clears prefs, calls widget.onLogout
  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.logout_rounded, color: Colors.red, size: 30),
          ),
          const SizedBox(height: 12),
          const Text('Logout', textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ]),
        content: const Text('Are you sure you want to logout?\nYou will need to login again.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, height: 1.5)),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(children: [
            Expanded(child: OutlinedButton(
              onPressed: () => Navigator.pop(ctx, false),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 13),
                side: const BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
            )),
            const SizedBox(width: 12),
            Expanded(child: ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 13),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Yes, Logout',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            )),
          ]),
        ],
      ),
    );

    if (confirmed == true) {
      final pref = await SharedPreferences.getInstance();
      await pref.clear(); // clear saved login data

      if (!mounted) return;

      // ✅ FIX: Call the onLogout callback passed from home_screen.dart
      // If onLogout is provided, use it (home_screen handles navigation)
      // Otherwise fall back to popping to root
      if (widget.onLogout != null) {
        widget.onLogout!();
      } else {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Account',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
          'This action cannot be undone.\nAll your data will be permanently deleted.',
          style: TextStyle(color: Colors.grey, height: 1.5)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F6F6),
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white, shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black87),
          ),
        ),
        title: const Text('Settings',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black87)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        children: [

          // ── PREFERENCES ──
          _SectionLabel(label: 'Preferences'),
          _SettingsCard(children: [
            _ToggleRow(icon: Icons.dark_mode_outlined,     label: 'Dark Mode',
                value: _darkMode,      onChanged: (v) => setState(() => _darkMode = v)),
            _Divider(),
            _ToggleRow(icon: Icons.notifications_outlined, label: 'Notifications',
                value: _notifications, onChanged: (v) => setState(() => _notifications = v)),
            _Divider(),
            _ToggleRow(icon: Icons.fingerprint,            label: 'Biometric Login',
                value: _biometric,     onChanged: (v) => setState(() => _biometric = v)),
            _Divider(),
            _TapRow(
              icon: Icons.language_outlined,
              label: 'Language',
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(_language, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey),
              ]),
              onTap: _pickLanguage,
            ),
          ]),

          // ── DATE & TIME ──
          _SectionLabel(label: 'Date & Time'),
          _SettingsCard(children: [
            _TapRow(
              icon: Icons.calendar_today_outlined,
              label: 'Date',
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(_formattedDate, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_ios, size: 13, color: Colors.grey),
              ]),
              onTap: _pickDate,
            ),
            _Divider(),
            _TapRow(
              icon: Icons.access_time_outlined,
              label: 'Time',
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(_formattedTime, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_ios, size: 13, color: Colors.grey),
              ]),
              onTap: _pickTime,
            ),
          ]),

          // ── GENERAL ──
          _SectionLabel(label: 'General'),
          _SettingsCard(children: [
            _TapRow(icon: Icons.lock_outline,          label: 'Change Password', onTap: () {}),
            _Divider(),
            _TapRow(icon: Icons.shield_outlined,       label: 'Privacy Policy',  onTap: () {}),
            _Divider(),
            _TapRow(icon: Icons.description_outlined,  label: 'Terms & Conditions', onTap: () {}),
            _Divider(),
            _TapRow(icon: Icons.info_outline,          label: 'About App',       onTap: () {}),
          ]),

          const SizedBox(height: 20),

          // ── DELETE ACCOUNT ──
          OutlinedButton.icon(
            onPressed: _showDeleteDialog,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFFFAAAA), width: 1.2),
              foregroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
            label: const Text('Delete Account',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.red)),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
//  PRIVATE HELPER WIDGETS
// ════════════════════════════════════════════════════════

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 22, bottom: 10, left: 4),
    child: Text(label, style: const TextStyle(fontSize: 13,
        fontWeight: FontWeight.w600, color: Colors.black45, letterSpacing: 0.3)),
  );
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.grey.shade100),
    ),
    child: Column(children: children),
  );
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleRow({required this.icon, required this.label,
      required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(children: [
        Container(
          width: 34, height: 34,
          decoration: BoxDecoration(color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(9)),
          child: Icon(icon, size: 18, color: Colors.black54),
        ),
        const SizedBox(width: 14),
        Expanded(child: Text(label,
            style: const TextStyle(fontSize: 14.5, color: Colors.black87))),
        CupertinoSwitch(
          value: value, onChanged: onChanged,
          activeColor: const Color(0xFF4F46E5),
        ),
      ]),
    );
  }
}

class _TapRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback onTap;
  const _TapRow({required this.icon, required this.label,
      required this.onTap, this.trailing});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(9)),
            child: Icon(icon, size: 18, color: Colors.black54),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text(label,
              style: const TextStyle(fontSize: 14.5, color: Colors.black87))),
          trailing ?? const Icon(Icons.arrow_forward_ios, size: 13, color: Colors.grey),
        ]),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Divider(
    height: 1, indent: 64, endIndent: 0, color: Colors.grey.shade100);
}