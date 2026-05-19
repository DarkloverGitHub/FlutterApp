import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

// ════════════════════════════════════════════════════════
//  PROFILE SCREEN  —  lib/screens/profile_screen.dart
//
//  FIXES vs previous version:
//  1. Purple header uses proper Stack so status bar +
//     title + avatar + name all fit without clipping
//  2. Settings gear icon properly positioned top-right
//  3. _isEditing starts FALSE  →  button shows "Edit"
//  4. Bottom nav matches design: Home | Profile | Settings
//  5. SafeArea only on sides/bottom, NOT top — so the
//     purple header fills completely behind the status bar
//  6. Added onUpdate callback for home_screen.dart compat
//  7. Added onLogout callback for settings compat
// ════════════════════════════════════════════════════════

const Color _kPurple     = Color(0xFF7C6DD8);
const Color _kPurpleDark = Color(0xFF5C4DB7);
const Color _kBg         = Color(0xFFF5F5F5);
const Color _kCard       = Colors.white;
const Color _kField      = Color(0xFFF8F8F8);

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onUpdate;  // called after saving profile
  final VoidCallback? onLogout;  // called after confirming logout

  const ProfileScreen({super.key, this.onUpdate, this.onLogout});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  // ── Data ──
  String _name  = 'Sudhir Yadad';
  String _email = 'Sudhiryadv@email.com';

  // ── FIX: starts false so button shows "Edit" not "Save" ──
  bool _isEditing = false;

  // ── Photo: null = show initials, non-null = show picked image ──
  String? _imagePath; // local file path saved to SharedPreferences

  // ── Image picker instance ──
  final ImagePicker _picker = ImagePicker();

  // ── Controllers ──
  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _dobCtrl;
  late TextEditingController _aboutCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl  = TextEditingController(text: 'Rahul Sharma');
    _emailCtrl = TextEditingController(text: 'rahul.sharma@email.com');
    _phoneCtrl = TextEditingController(text: '+91 98765 43210');
    _dobCtrl   = TextEditingController(text: '15 May 1995');
    _aboutCtrl = TextEditingController(
      text: 'Passionate about mobile app development and exploring new technologies.');
    _loadProfile();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();  _emailCtrl.dispose();
    _phoneCtrl.dispose(); _dobCtrl.dispose(); _aboutCtrl.dispose();
    super.dispose();
  }

  // ── Load saved values from SharedPreferences ──
  Future<void> _loadProfile() async {
    final pref = await SharedPreferences.getInstance();
    final savedName  = pref.getString('name');
    final savedEmail = pref.getString('email');
    final savedImage = pref.getString('image_path'); // load saved photo path
    if (!mounted) return;
    setState(() {
      if (savedName  != null) { _name  = savedName;  _nameCtrl.text  = savedName;  }
      if (savedEmail != null) { _email = savedEmail; _emailCtrl.text = savedEmail; }
      if (savedImage != null && File(savedImage).existsSync()) {
        _imagePath = savedImage; // restore photo if file still exists
      }
    });
  }

  // ── Show bottom sheet: Camera | Gallery | Remove photo ──
  void _showPhotoPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            // Drag handle
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('Profile Photo',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const Divider(height: 1),

            // Camera option
            ListTile(
              leading: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: _kPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.camera_alt_outlined, color: _kPurple),
              ),
              title: const Text('Take a Photo'),
              subtitle: const Text('Use your camera'),
              onTap: () { Navigator.pop(ctx); _pickImage(ImageSource.camera); },
            ),

            // Gallery option
            ListTile(
              leading: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.photo_library_outlined, color: Colors.green),
              ),
              title: const Text('Choose from Gallery'),
              subtitle: const Text('Pick an existing photo'),
              onTap: () { Navigator.pop(ctx); _pickImage(ImageSource.gallery); },
            ),

            // Remove photo (only show if photo is set)
            if (_imagePath != null)
              ListTile(
                leading: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.delete_outline, color: Colors.red),
                ),
                title: const Text('Remove Photo',
                  style: TextStyle(color: Colors.red)),
                onTap: () { Navigator.pop(ctx); _removePhoto(); },
              ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  // ── Pick image from camera or gallery ──
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 80,   // compress to save storage
        maxWidth: 512,      // cap resolution
        maxHeight: 512,
      );
      if (picked == null) return; // user cancelled

      // Save path to SharedPreferences so it persists across restarts
      final pref = await SharedPreferences.getInstance();
      await pref.setString('image_path', picked.path);

      if (!mounted) return;
      setState(() => _imagePath = picked.path);
    } catch (e) {
      // Handle permission denied or picker error
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Could not pick image: $e'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  // ── Remove photo → back to initials ──
  Future<void> _removePhoto() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove('image_path');
    setState(() => _imagePath = null);
  }

  // ── Save profile & notify parent ──
  Future<void> _saveProfile() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('name',  _nameCtrl.text.trim());
    await pref.setString('email', _emailCtrl.text.trim());

    setState(() {
      _name      = _nameCtrl.text.trim();
      _email     = _emailCtrl.text.trim();
      _isEditing = false;   // back to read-only mode
    });

    widget.onUpdate?.call(); // refresh home screen greeting

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Profile updated ✓'),
      backgroundColor: _kPurple,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  // ── Date of birth picker ──
  Future<void> _pickDob() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1995, 5, 15),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.light(primary: _kPurple)),
        child: child!,
      ),
    );
    if (picked == null) return;
    const mo = ['Jan','Feb','Mar','Apr','May','Jun',
                 'Jul','Aug','Sep','Oct','Nov','Dec'];
    setState(() => _dobCtrl.text = '${picked.day} ${mo[picked.month-1]} ${picked.year}');
  }

  // ── Logout confirmation dialog ──
  Future<void> _logout() async {
    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
                color: _kPurple.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.logout_rounded, color: _kPurple, size: 30),
          ),
          const SizedBox(height: 12),
          const Text('Logout', textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ]),
        content: const Text('Are you sure you want to logout?',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, height: 1.5)),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(children: [
            Expanded(child: OutlinedButton(
              onPressed: () => Navigator.pop(ctx, false),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 13),
                side: const BorderSide(color: _kPurple),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Cancel',
                  style: TextStyle(color: _kPurple, fontWeight: FontWeight.w600)),
            )),
            const SizedBox(width: 12),
            Expanded(child: ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 13),
                backgroundColor: _kPurple, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Yes, Logout',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            )),
          ]),
        ],
      ),
    );

    if (ok == true) {
      final pref = await SharedPreferences.getInstance();
      await pref.clear();
      if (!mounted) return;
      if (widget.onLogout != null) {
        widget.onLogout!();
      } else {
        Navigator.of(context).popUntil((r) => r.isFirst);
      }
    }
  }

  // ── Initials from name ──
  String get _initials {
    final parts = _name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return _name.isNotEmpty ? _name[0].toUpperCase() : 'U';
  }

  // ════════════════════════════════════════════════════════
  //  BUILD
  // ════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {

    // Make status bar icons white over the purple header
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: _kBg,

      // ── NO AppBar — we build a custom header inside body ──
      body: Column(
        children: [

          // ════════════════════════════════════════
          //  PURPLE HEADER  (fills behind status bar)
          // ════════════════════════════════════════
          Container(
            width: double.infinity,
            color: _kPurple,
            // padding: top = status bar height + extra; sides & bottom manual
            child: SafeArea(
              // only avoid left/right/bottom system UI, NOT the top status bar
              // so the purple color fills behind the clock/wifi icons
              left: false, right: false, bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  children: [

                    // ── Row: back space | "Profile" title | gear icon ──
                    Row(
                      children: [
                        // Left: invisible placeholder so title stays centered
                        const SizedBox(width: 40),

                        // Centre: "Profile" title
                        const Expanded(
                          child: Text(
                            'Profile',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        // Right: settings gear icon
                        GestureDetector(
                          onTap: () {}, // navigate to Settings if needed
                          child: Container(
                            width: 40, height: 40,
                            alignment: Alignment.centerRight,
                            child: const Icon(
                              Icons.settings_outlined,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ── Avatar with edit badge (tappable to pick photo) ──
                    GestureDetector(
                      onTap: _showPhotoPicker, // tap anywhere on avatar to open picker
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Show picked photo OR initials fallback
                          CircleAvatar(
                            radius: 44,
                            backgroundColor: Colors.white.withOpacity(0.25),
                            // backgroundImage: shows the picked photo
                            backgroundImage: _imagePath != null
                                ? FileImage(File(_imagePath!))
                                : null,
                            // child: only shown when no photo (backgroundImage is null)
                            child: _imagePath == null
                                ? Text(
                                    _initials,
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  )
                                : null,
                          ),
                          // Camera/edit badge bottom-right
                          Positioned(
                            bottom: 2, right: 2,
                            child: Container(
                              width: 26, height: 26,
                              decoration: BoxDecoration(
                                color: _kPurpleDark,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(Icons.camera_alt, size: 13, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Name ──
                    Text(
                      _name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // ── Email ──
                    Text(
                      _email,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ════════════════════════════════════════
          //  SCROLLABLE CONTENT
          // ════════════════════════════════════════
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                children: [

                  // ── Personal Information card ──
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Card header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: const [
                              Icon(Icons.person_outline, color: _kPurple, size: 20),
                              SizedBox(width: 8),
                              Text('Personal Information',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            ]),

                            // FIX: shows "Edit" by default, "Save" only when editing
                            GestureDetector(
                              onTap: () {
                                if (_isEditing) {
                                  _saveProfile();
                                } else {
                                  setState(() => _isEditing = true);
                                }
                              },
                              child: Text(
                                _isEditing ? 'Save' : 'Edit',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: _kPurple,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Full Name
                        _Label('Full Name'),
                        _Field(ctrl: _nameCtrl, editing: _isEditing),
                        const SizedBox(height: 12),

                        // Email
                        _Label('Email'),
                        _Field(ctrl: _emailCtrl, editing: _isEditing,
                            keyboard: TextInputType.emailAddress),
                        const SizedBox(height: 12),

                        // Phone Number
                        _Label('Phone Number'),
                        _Field(ctrl: _phoneCtrl, editing: _isEditing,
                            keyboard: TextInputType.phone),
                        const SizedBox(height: 12),

                        // Date of Birth
                        _Label('Date of Birth'),
                        GestureDetector(
                          onTap: _isEditing ? _pickDob : null,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              color: _kField,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_dobCtrl.text,
                                    style: const TextStyle(fontSize: 14)),
                                Icon(Icons.calendar_today_outlined,
                                    size: 16,
                                    color: _isEditing ? _kPurple : Colors.grey),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ── About Me card ──
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: const [
                          Icon(Icons.description_outlined, color: _kPurple, size: 20),
                          SizedBox(width: 8),
                          Text('About Me',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        ]),
                        const SizedBox(height: 14),
                        _isEditing
                          ? TextField(
                              controller: _aboutCtrl,
                              maxLines: 3,
                              style: const TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                filled: true, fillColor: _kField,
                                contentPadding: const EdgeInsets.all(12),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey.shade200)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey.shade200)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: _kPurple)),
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _kField,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Text(_aboutCtrl.text,
                                style: const TextStyle(
                                    fontSize: 14, height: 1.55, color: Colors.black87)),
                            ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Logout button ──
                  SizedBox(
                    width: double.infinity, height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _logout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _kPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.logout_rounded, size: 20),
                      label: const Text('Logout',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // NOTE: No _BottomNav here.
          // home_screen.dart already wraps ProfileScreen inside
          // a Scaffold with its own BottomAppBar, so adding one
          // here caused TWO bottom navs to appear.
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
//  PRIVATE HELPERS
// ════════════════════════════════════════════════════════

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey.shade100),
    ),
    child: child,
  );
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey)),
  );
}

class _Field extends StatelessWidget {
  final TextEditingController ctrl;
  final bool editing;
  final TextInputType keyboard;
  const _Field({required this.ctrl, required this.editing,
      this.keyboard = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    final box = BoxDecoration(
      color: const Color(0xFFF8F8F8),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade200),
    );
    return editing
        ? TextField(
            controller: ctrl,
            keyboardType: keyboard,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              filled: true, fillColor: const Color(0xFFF8F8F8),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade200)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade200)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: _kPurple, width: 1.5)),
            ),
          )
        : Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: box,
            child: Text(ctrl.text, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          );
  }
}

// _BottomNav removed — home_screen.dart provides the bottom navigation bar.
// ProfileScreen is rendered as a tab body inside HomeScreen's Scaffold,
// so it must NOT have its own bottom nav or it will appear twice.