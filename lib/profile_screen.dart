import 'package:flutter/material.dart';
import 'login_screen.dart';

// ══════════════════════════════════════════════
//  PROFILE SCREEN
//  File: lib/screens/profile_screen.dart
//
//  This file contains:
//   1. ProfileScreen      → main profile page
//   2. _ProfileMenuItem   → reusable menu row widget
//
//  Widgets used:
//   • SafeArea            → keeps content below status bar
//   • Column              → vertical layout
//   • Stack + Positioned  → edit pencil overlaps avatar
//   • CircleAvatar        → round avatar with initials
//   • InkWell             → tappable menu rows with ripple
//   • Divider             → thin line between menu items
//   • Navigator           → logout clears the whole stack
// ══════════════════════════════════════════════

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // ── 1. Header ──
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Profile',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.settings_outlined, size: 24),
              ],
            ),
          ),

          // ── 2. Scrollable body ──
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  // ── 3. Avatar with edit badge ──
                  // Stack lets the pencil badge sit on top of the circle
                  Stack(
                    children: [
                      // Initials avatar
                      CircleAvatar(
                        radius: 46,
                        backgroundColor: const Color(0xFFC0D4F5),
                        child: const Text(
                          'JD',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3478F6),
                          ),
                        ),
                      ),
                      // Edit pencil — pinned to bottom-right of Stack
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3478F6),
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ── 4. Name & Email ──
                  const Text(
                    'Sudhir Yadav',
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Sudhiryadav@email.com',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 30),

                  // ── 5. Menu Items ──
                  // Each row is a _ProfileMenuItem widget
                  const _ProfileMenuItem(
                    icon: Icons.person_outline,
                    label: 'Personal Information',
                  ),
                  const _ProfileMenuItem(
                    icon: Icons.settings_outlined,
                    label: 'Account Settings',
                  ),
                  const _ProfileMenuItem(
                    icon: Icons.shield_outlined,
                    label: 'Security',
                  ),
                  const _ProfileMenuItem(
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                  ),
                  const _ProfileMenuItem(
                    icon: Icons.help_outline,
                    label: 'Help & Support',
                  ),

                  // ── 6. Logout (red text, clears navigation stack) ──
                  _ProfileMenuItem(
                    icon: Icons.logout,
                    label: 'Logout',
                    labelColor: const Color(0xFFE24B4A), // red
                    onTap: () {
                      // pushAndRemoveUntil → clears ALL screens from stack
                      // then opens LoginScreen fresh
                      // (route) => false means: remove every route
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════
//  PROFILE MENU ITEM  (reusable widget)
//
//  One row: [icon]  Label text  [chevron >]
//  InkWell gives a ripple effect on tap.
// ══════════════════════════════════════════════
class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? labelColor;    // defaults to normal text color
  final VoidCallback? onTap;  // what happens when tapped

  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    this.labelColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap ?? () {}, // if no onTap provided, do nothing
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                // Leading icon
                Icon(
                  icon,
                  size: 22,
                  color: labelColor ?? Colors.grey.shade600,
                ),
                const SizedBox(width: 16),

                // Label text (expands to fill space)
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      // Use custom color if provided (e.g. red for logout)
                      // Otherwise use default text color from theme
                      color: labelColor ??
                          Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),

                // Chevron arrow on the right
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade300,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
        // Thin divider line below each item
        Divider(height: 1, color: Colors.grey.shade200),
      ],
    );
  }
}