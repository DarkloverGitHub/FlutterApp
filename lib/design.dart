import 'package:flutter/material.dart';
import 'settings_screen.dart';
import 'card.dart';
import 'login_screen.dart';

class DesignScreen extends StatefulWidget {
  const DesignScreen({super.key});

  @override
  State<DesignScreen> createState() => _DesignScreenState();
}

class _DesignScreenState extends State<DesignScreen> {
  bool _notifications = true;
  bool _darkMode = false;
  bool _termsAgreed = true;
  bool _newsletter = false;

  final TextEditingController _usernameController =
      TextEditingController(text: 'Sudhir Yadav');
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

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
        titleSpacing: 0,
        title: const Row(
          children: [
            Icon(Icons.person_outline, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              "User Settings",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          // ✅ Call Log icon
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            tooltip: 'Call Log',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CallLogScreen(),
                ),
              );
            },
          ),
          // ✅ Settings icon
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Avatar
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEAE8FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_outline_rounded,
                    size: 42,
                    color: Color(0xFF6C63FF),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // Username
              const Text("Username",
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9E9E9E),
                      fontWeight: FontWeight.w400)),
              const SizedBox(height: 6),
              TextField(
                controller: _usernameController,
                style: const TextStyle(
                    fontSize: 14, color: Color(0xFF1A1A1A)),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 13),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                        color: Color(0xFFDDDDDD), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                        color: Color(0xFF6C63FF), width: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Email
              const Text("Email",
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9E9E9E),
                      fontWeight: FontWeight.w400)),
              const SizedBox(height: 6),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                    fontSize: 14, color: Color(0xFF1A1A1A)),
                decoration: InputDecoration(
                  hintText: "Enter email...",
                  hintStyle:
                      const TextStyle(color: Color(0xFFBBBBBB)),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 13),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                        color: Color(0xFFDDDDDD), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                        color: Color(0xFF6C63FF), width: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Notifications
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.coffee_outlined,
                          size: 18, color: Color(0xFF444444)),
                      SizedBox(width: 10),
                      Text("Notifications",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF222222),
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Switch(
                    value: _notifications,
                    onChanged: (val) =>
                        setState(() => _notifications = val),
                    activeColor: Colors.white,
                    activeTrackColor: const Color(0xFF6C63FF),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: const Color(0xFFCCCCCC),
                    trackOutlineColor:
                        WidgetStateProperty.all(Colors.transparent),
                  ),
                ],
              ),

              // Dark Mode (disabled)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.dark_mode_outlined,
                          size: 18,
                          color: const Color(0xFF444444).withOpacity(0.4)),
                      const SizedBox(width: 10),
                      Text("Dark mode",
                          style: TextStyle(
                              fontSize: 14,
                              color:
                                  const Color(0xFF222222).withOpacity(0.4),
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Switch(
                    value: _darkMode,
                    onChanged: null,
                    activeColor: Colors.white,
                    activeTrackColor: const Color(0xFF6C63FF),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: const Color(0xFFCCCCCC),
                    trackOutlineColor:
                        WidgetStateProperty.all(Colors.transparent),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Terms Checkbox
              Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _termsAgreed,
                      activeColor: const Color(0xFF6C63FF),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      side: const BorderSide(
                          color: Color(0xFFAAAAAA), width: 1.5),
                      onChanged: (val) =>
                          setState(() => _termsAgreed = val!),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text("I agree to terms & conditions",
                      style: TextStyle(
                          fontSize: 13, color: Color(0xFF222222))),
                ],
              ),

              const SizedBox(height: 4),

              // Newsletter Checkbox
              Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _newsletter,
                      activeColor: const Color(0xFF6C63FF),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      side: const BorderSide(
                          color: Color(0xFFAAAAAA), width: 1.5),
                      onChanged: (val) =>
                          setState(() => _newsletter = val!),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text("Subscribe to newsletter",
                      style: TextStyle(
                          fontSize: 13,
                          color:
                              const Color(0xFF222222).withOpacity(0.45))),
                ],
              ),

              const SizedBox(height: 18),

              // Dashed Photo Picker
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Open photo picker'),
                      backgroundColor: Color(0xFF6C63FF),
                    ),
                  );
                },
                child: CustomPaint(
                  painter: _DashedRoundedBorderPainter(
                    color: const Color(0xFF6C63FF),
                    borderRadius: 10,
                    dashWidth: 7,
                    dashGap: 5,
                    strokeWidth: 1.5,
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F3FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_outlined,
                            color: Color(0xFF6C63FF), size: 18),
                        SizedBox(width: 8),
                        Text(
                          "Tap to choose a profile photo",
                          style: TextStyle(
                            color: Color(0xFF6C63FF),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Save Changes Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Changes saved!'),
                        backgroundColor: Color(0xFF6C63FF),
                      ),
                    );
                  },
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Dashed Border Painter ──────────────────────────────────────
class _DashedRoundedBorderPainter extends CustomPainter {
  final Color color;
  final double borderRadius;
  final double dashWidth;
  final double dashGap;
  final double strokeWidth;

  const _DashedRoundedBorderPainter({
    required this.color,
    required this.borderRadius,
    required this.dashWidth,
    required this.dashGap,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(strokeWidth / 2, strokeWidth / 2,
          size.width - strokeWidth, size.height - strokeWidth),
      Radius.circular(borderRadius),
    );

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics().toList();

    for (final metric in metrics) {
      double distance = 0;
      bool draw = true;
      while (distance < metric.length) {
        final double len = draw ? dashWidth : dashGap;
        final double end =
            (distance + len).clamp(0.0, metric.length);
        if (draw) {
          canvas.drawPath(metric.extractPath(distance, end), paint);
        }
        distance += len;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRoundedBorderPainter old) =>
      old.color != color ||
      old.dashWidth != dashWidth ||
      old.dashGap != dashGap ||
      old.strokeWidth != strokeWidth;
}