import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'locallogin.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  Widget get _currentPage {
    switch (_currentIndex) {
      case 0:  return const _HomeTab();
      case 1:  return const _TransactionsTab();
      case 3:  return const _CardsTab();
      case 4:  return const _ProfileTab();
      default: return const _HomeTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: _currentPage,
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
        color: Colors.white,
        child: SizedBox(
          height: 58,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home_outlined,        activeIcon: Icons.home,         label: 'Home',         index: 0, current: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
              _NavItem(icon: Icons.receipt_long_outlined, activeIcon: Icons.receipt_long, label: 'Transactions', index: 1, current: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
              const SizedBox(width: 48),
              _NavItem(icon: Icons.credit_card_outlined,  activeIcon: Icons.credit_card,  label: 'Cards',        index: 3, current: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
              _NavItem(icon: Icons.person_outline,        activeIcon: Icons.person,        label: 'Profile',      index: 4, current: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
//  HOME TAB
// ════════════════════════════════════════════════════════
class _HomeTab extends StatefulWidget {
  const _HomeTab();
  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  String _username = 'User';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final pref = await SharedPreferences.getInstance();
    setState(() => _username = pref.getString('username') ?? 'User');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Hi, $_username! 👋',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const Text('Welcome back', style: TextStyle(color: Colors.grey, fontSize: 14)),
                ]),
                Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: const Icon(Icons.notifications_outlined, size: 22),
                ),
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
                    const Text('\$1,250.00', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Row(children: const [
                      Text('View Details', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right, color: Colors.white70, size: 16),
                    ]),
                  ])),
                  const Icon(Icons.account_balance_wallet, size: 56, color: Colors.white24),
                ],
              ),
            ),
            const SizedBox(height: 26),
            const Text('Quick Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _QuickAction(icon: Icons.send,               label: 'Send',    bgColor: Color(0xFFE7EFFE), iconColor: Color(0xFF3478F6)),
                _QuickAction(icon: Icons.download_outlined,  label: 'Receive', bgColor: Color(0xFFE6F9EF), iconColor: Color(0xFF1D9E75)),
                _QuickAction(icon: Icons.add_circle_outline, label: 'Top Up',  bgColor: Color(0xFFF2E9FF), iconColor: Color(0xFF8B5CF6)),
                _QuickAction(icon: Icons.more_horiz,         label: 'More',    bgColor: Color(0xFFF0F0F0), iconColor: Colors.grey),
              ],
            ),
            const SizedBox(height: 26),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recent Transactions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                TextButton(onPressed: () {}, child: const Text('See All', style: TextStyle(color: Color(0xFF3478F6), fontSize: 13))),
              ],
            ),
            const _TransactionItem(letter: 'A',  bgColor: Colors.orange,       name: 'Amazon',    cat: 'Shopping',     amt: '-\$60.00',    date: 'May 12', isDebit: true),
            const _TransactionItem(letter: 'S',  bgColor: Color(0xFF00704A),   name: 'Starbucks', cat: 'Food & Drink', amt: '-\$5.25',     date: 'May 12', isDebit: true),
            const _TransactionItem(letter: '\$', bgColor: Colors.green,         name: 'Salary',    cat: 'Income',       amt: '+\$1,500.00', date: 'May 10', isDebit: false),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
//  PROFILE TAB  —  with AlertDialog logout confirmation
// ════════════════════════════════════════════════════════
class _ProfileTab extends StatefulWidget {
  const _ProfileTab();
  @override
  State<_ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<_ProfileTab> {
  String _username = 'User';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final pref = await SharedPreferences.getInstance();
    setState(() => _username = pref.getString('username') ?? 'User');
  }

  // ════════════════════════════════════════════════════
  //  LOGOUT  —  shows "Are you sure?" AlertDialog first
  // ════════════════════════════════════════════════════
  Future<void> _logout() async {
    // showDialog<bool> returns:
    //   true  → user tapped "Yes, Logout"
    //   false → user tapped "Cancel"
    //   null  → user dismissed dialog (we disabled this with barrierDismissible: false)
    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // force user to tap a button
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          // ── Red warning icon + "Logout" heading ──
          title: Column(
            children: [
              Container(
                width: 68, height: 68,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEB),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFE24B4A).withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Color(0xFFE24B4A),
                  size: 34,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Logout',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          // ── Confirmation message ──
          content: const Text(
            'Are you sure you want to logout?',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.6),
          ),

          // ── Two buttons: Cancel  |  Yes, Logout ──
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          actions: [
            Row(
              children: [
                // CANCEL — blue outlined button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx, false), // returns false
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFF3478F6)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFF3478F6),
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // YES LOGOUT — red filled button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx, true), // returns true
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: const Color(0xFFE24B4A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    // ── Only proceed if user tapped "Yes, Logout" ──
    if (confirmed == true) {
      final pref = await SharedPreferences.getInstance();
      await pref.clear(); // wipes saved username & password

      if (!mounted) return; // safety: widget might be gone after await

      // Go to Login and remove ALL screens from the back stack
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Localstoragelogin()),
        (route) => false,
      );
    }
    // confirmed == false → Cancel tapped → do nothing, stay on Profile
  }

  @override
  Widget build(BuildContext context) {
    final String initials =
        _username.isNotEmpty ? _username[0].toUpperCase() : 'U';

    return SafeArea(
      child: Column(
        children: [
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
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 46,
                        backgroundColor: const Color(0xFFC0D4F5),
                        child: Text(initials,
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF3478F6))),
                      ),
                      Positioned(
                        bottom: 2, right: 2,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3478F6),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.edit, size: 13, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(_username, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('$_username@gmail.com', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 28),
                  _ProfileMenuItem(icon: Icons.person_outline,         label: 'Personal Information', onTap: () {}),
                  _ProfileMenuItem(icon: Icons.settings_outlined,      label: 'Account Settings',     onTap: () {}),
                  _ProfileMenuItem(icon: Icons.shield_outlined,        label: 'Security',             onTap: () {}),
                  _ProfileMenuItem(icon: Icons.notifications_outlined, label: 'Notifications',        onTap: () {}),
                  _ProfileMenuItem(icon: Icons.help_outline,           label: 'Help & Support',       onTap: () {}),

                  // ── Logout — triggers AlertDialog ──
                  _ProfileMenuItem(
                    icon: Icons.logout,
                    label: 'Logout',
                    labelColor: const Color(0xFFE24B4A),
                    onTap: _logout, // ← opens the confirmation dialog
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

// ════════════════════════════════════════════════════════
//  PLACEHOLDER TABS
// ════════════════════════════════════════════════════════
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
//  REUSABLE WIDGETS
// ════════════════════════════════════════════════════════
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
    final Color color = isActive ? const Color(0xFF3478F6) : Colors.grey;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(isActive ? activeIcon : icon, color: color, size: 24),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 11, color: color)),
      ]),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bgColor, iconColor;
  const _QuickAction({required this.icon, required this.label, required this.bgColor, required this.iconColor});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: 56, height: 56,
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16)),
        child: Icon(icon, color: iconColor, size: 26),
      ),
      const SizedBox(height: 6),
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
    ]);
  }
}

class _TransactionItem extends StatelessWidget {
  final String letter, name, cat, amt, date;
  final Color bgColor;
  final bool isDebit;
  const _TransactionItem({required this.letter, required this.bgColor, required this.name,
      required this.cat, required this.amt, required this.date, required this.isDebit});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        CircleAvatar(radius: 22, backgroundColor: bgColor,
            child: Text(letter, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          Text(cat, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(amt, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14,
              color: isDebit ? const Color(0xFFE24B4A) : const Color(0xFF1D9E75))),
          Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ]),
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
    return Column(children: [
      InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(children: [
            Icon(icon, size: 22, color: labelColor ?? Colors.grey.shade600),
            const SizedBox(width: 16),
            Expanded(child: Text(label,
                style: TextStyle(fontSize: 15,
                    color: labelColor ?? Theme.of(context).colorScheme.onSurface))),
            Icon(Icons.chevron_right, color: Colors.grey.shade300, size: 22),
          ]),
        ),
      ),
      Divider(height: 1, color: Colors.grey.shade200),
    ]);
  }
}