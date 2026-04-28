import 'package:flutter/material.dart';
import 'design.dart';
import 'card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<_TaskItem> _tasks = const [
    _TaskItem(
      icon: Icons.insert_drive_file_outlined,
      iconBg: Color(0xFFEDE9FF),
      iconColor: Color(0xFF6C63FF),
      title: 'Design mobile app',
      subtitle: 'UI/UX Design',
      status: 'In Progress',
    ),
    _TaskItem(
      icon: Icons.code,
      iconBg: Color(0xFFE0F0FF),
      iconColor: Color(0xFF2196F3),
      title: 'Develop API',
      subtitle: 'Backend',
      status: 'In Progress',
    ),
    _TaskItem(
      icon: Icons.check_circle,
      iconBg: Color(0xFFE6F9EF),
      iconColor: Color(0xFF34A853),
      title: 'Fix bugs',
      subtitle: 'Bug Fixes',
      status: 'Completed',
    ),
    _TaskItem(
      icon: Icons.access_time,
      iconBg: Color(0xFFFFF3E0),
      iconColor: Color(0xFFFFA726),
      title: 'Update documentation',
      subtitle: 'Documentation',
      status: 'Pending',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EFF8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Header ─────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Good morning,",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF6C63FF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Sudhir Yadav",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  // ✅ Avatar → taps to User Settings
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DesignScreen()),
                      );
                    },
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD8D0FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 36,
                        color: Color(0xFF6C63FF),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Overview Card ──────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Overview",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _OverviewTile(
                            bgColor: const Color(0xFFF0EEFF),
                            icon: Icons.insert_drive_file_outlined,
                            iconColor: const Color(0xFF6C63FF),
                            count: '12',
                            label: 'Tasks',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _OverviewTile(
                            bgColor: const Color(0xFFE8F4FF),
                            icon: Icons.calendar_today_outlined,
                            iconColor: const Color(0xFF2196F3),
                            count: '5',
                            label: 'In Progress',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _OverviewTile(
                            bgColor: const Color(0xFFE8F8EF),
                            icon: Icons.check_circle,
                            iconColor: const Color(0xFF34A853),
                            count: '7',
                            label: 'Completed',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── My Tasks Card ──────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "My Tasks",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        // ✅ View all → Call Log
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CallLogScreen()),
                            );
                          },
                          child: const Text(
                            "View all",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6C63FF),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ..._tasks.map((task) => _TaskCard(task: task)),
                  ],
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),

      // ── Bottom Navigation ──────────────────────────────────
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Home tab
                GestureDetector(
                  onTap: () => setState(() => _selectedIndex = 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home_rounded,
                        color: _selectedIndex == 0
                            ? const Color(0xFF6C63FF)
                            : Colors.grey,
                        size: 26,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Home",
                        style: TextStyle(
                          fontSize: 12,
                          color: _selectedIndex == 0
                              ? const Color(0xFF6C63FF)
                              : Colors.grey,
                          fontWeight: _selectedIndex == 0
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),

                // ✅ FAB → Add task snackbar
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Add new task'),
                        backgroundColor: Color(0xFF6C63FF),
                      ),
                    );
                  },
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: Color(0xFF6C63FF),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x556C63FF),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),

                // ✅ Profile tab → User Settings
                GestureDetector(
                  onTap: () {
                    setState(() => _selectedIndex = 1);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DesignScreen()),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_outline_rounded,
                        color: _selectedIndex == 1
                            ? const Color(0xFF6C63FF)
                            : Colors.grey,
                        size: 26,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 12,
                          color: _selectedIndex == 1
                              ? const Color(0xFF6C63FF)
                              : Colors.grey,
                          fontWeight: _selectedIndex == 1
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Overview Tile ──────────────────────────────────────────────
class _OverviewTile extends StatelessWidget {
  final Color bgColor;
  final IconData icon;
  final Color iconColor;
  final String count;
  final String label;

  const _OverviewTile({
    required this.bgColor,
    required this.icon,
    required this.iconColor,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 10),
          Text(
            count,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Task Item Model ────────────────────────────────────────────
class _TaskItem {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String status;

  const _TaskItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.status,
  });
}

// ── Task Card ──────────────────────────────────────────────────
class _TaskCard extends StatelessWidget {
  final _TaskItem task;

  const _TaskCard({required this.task});

  Color get _statusBg {
    switch (task.status) {
      case 'In Progress':
        return const Color(0xFFEDE9FF);
      case 'Completed':
        return const Color(0xFFE6F9EF);
      case 'Pending':
        return const Color(0xFFFFF3E0);
      default:
        return const Color(0xFFF5F5F5);
    }
  }

  Color get _statusColor {
    switch (task.status) {
      case 'In Progress':
        return const Color(0xFF6C63FF);
      case 'Completed':
        return const Color(0xFF34A853);
      case 'Pending':
        return const Color(0xFFFFA726);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: task.iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(task.icon, color: task.iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  task.subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _statusBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              task.status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}