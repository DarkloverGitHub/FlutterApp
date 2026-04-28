import 'package:flutter/material.dart';

class CallLogEntry {
  final String phoneNumber;
  final String callType;

  const CallLogEntry({
    required this.phoneNumber,
    required this.callType,
  });
}

class CallLogScreen extends StatefulWidget {
  const CallLogScreen({super.key});

  @override
  State<CallLogScreen> createState() => _CallLogScreenState();
}

class _CallLogScreenState extends State<CallLogScreen> {
  final List<CallLogEntry> _entries = [
    const CallLogEntry(phoneNumber: '6666677897', callType: 'Incoming'),
    const CallLogEntry(phoneNumber: '7777777777', callType: 'Outgoing'),
    const CallLogEntry(phoneNumber: '3498789678', callType: 'Incoming'),
    const CallLogEntry(phoneNumber: '7897989780', callType: 'Missed'),
    const CallLogEntry(phoneNumber: '8989898989', callType: 'Outgoing'),
    const CallLogEntry(phoneNumber: '9812345678', callType: 'Missed'),
    const CallLogEntry(phoneNumber: '9800112233', callType: 'Incoming'),
  ];

  // ── Add new entry ────────────────────────────────────────────
  void _showAddDialog() {
    final TextEditingController phoneController = TextEditingController();
    String selectedType = 'Incoming';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Add Call Log",
            style: TextStyle(
              color: Color(0xFF6C63FF),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Phone number field
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Enter phone number",
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(
                    Icons.phone,
                    color: Color(0xFF6C63FF),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Call type selector
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedType,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: Color(0xFF6C63FF)),
                    items: ['Incoming', 'Outgoing', 'Missed']
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Row(
                                children: [
                                  Icon(
                                    _callIcon(type),
                                    color: _callIconColor(type),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(type),
                                ],
                              ),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => selectedType = val);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (phoneController.text.trim().isNotEmpty) {
                  setState(() {
                    _entries.insert(
                      0,
                      CallLogEntry(
                        phoneNumber: phoneController.text.trim(),
                        callType: selectedType,
                      ),
                    );
                  });
                  Navigator.pop(ctx);
                }
              },
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }

  IconData _callIcon(String type) {
    switch (type) {
      case 'Incoming':
        return Icons.call_received;
      case 'Outgoing':
        return Icons.call_made;
      case 'Missed':
        return Icons.call_missed;
      default:
        return Icons.call;
    }
  }

  Color _callIconColor(String type) {
    switch (type) {
      case 'Incoming':
        return const Color(0xFF34A853);
      case 'Outgoing':
        return const Color(0xFF6C63FF);
      case 'Missed':
        return const Color(0xFFEA4335);
      default:
        return Colors.grey;
    }
  }

  Color _statusBg(String type) {
    switch (type) {
      case 'Incoming':
        return const Color(0xFFE6F9EF);
      case 'Outgoing':
        return const Color(0xFFEDE9FF);
      case 'Missed':
        return const Color(0xFFFFEBEA);
      default:
        return const Color(0xFFF5F5F5);
    }
  }

  Color _statusColor(String type) {
    switch (type) {
      case 'Incoming':
        return const Color(0xFF34A853);
      case 'Outgoing':
        return const Color(0xFF6C63FF);
      case 'Missed':
        return const Color(0xFFEA4335);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EFF8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C63FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            Icon(Icons.call, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              "Call Log",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          // ── Call count badge ─────────────────────────────
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "${_entries.length} calls",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),

      // ── Summary strip ──────────────────────────────────────
      body: Column(
        children: [
          Container(
            color: const Color(0xFF6C63FF),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                _SummaryChip(
                  icon: Icons.call_received,
                  label: "Incoming",
                  count: _entries
                      .where((e) => e.callType == 'Incoming')
                      .length,
                  color: const Color(0xFF34A853),
                ),
                const SizedBox(width: 10),
                _SummaryChip(
                  icon: Icons.call_made,
                  label: "Outgoing",
                  count: _entries
                      .where((e) => e.callType == 'Outgoing')
                      .length,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                _SummaryChip(
                  icon: Icons.call_missed,
                  label: "Missed",
                  count: _entries
                      .where((e) => e.callType == 'Missed')
                      .length,
                  color: const Color(0xFFFF6B6B),
                ),
              ],
            ),
          ),

          // ── Call list ──────────────────────────────────────
          Expanded(
            child: _entries.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.call_outlined,
                            size: 64, color: Color(0xFFCCCCCC)),
                        SizedBox(height: 12),
                        Text(
                          "No call logs yet",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    itemCount: _entries.length,
                    itemBuilder: (context, index) {
                      final entry = _entries[index];
                      return _CallCard(
                        entry: entry,
                        callIcon: _callIcon(entry.callType),
                        callIconColor: _callIconColor(entry.callType),
                        statusBg: _statusBg(entry.callType),
                        statusColor: _statusColor(entry.callType),
                        onDial: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Dialing ${entry.phoneNumber}...'),
                              backgroundColor: const Color(0xFF6C63FF),
                            ),
                          );
                        },
                        onDelete: () {
                          setState(() => _entries.removeAt(index));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Call log removed'),
                              backgroundColor: Color(0xFFEA4335),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),

      // ── FAB to add new call log ────────────────────────────
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6C63FF),
        onPressed: _showAddDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// ── Summary Chip ───────────────────────────────────────────────
class _SummaryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  const _SummaryChip({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$count",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Call Card ──────────────────────────────────────────────────
class _CallCard extends StatelessWidget {
  final CallLogEntry entry;
  final IconData callIcon;
  final Color callIconColor;
  final Color statusBg;
  final Color statusColor;
  final VoidCallback onDial;
  final VoidCallback onDelete;

  const _CallCard({
    required this.entry,
    required this.callIcon,
    required this.callIconColor,
    required this.statusBg,
    required this.statusColor,
    required this.onDial,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Call type icon box
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(callIcon, color: callIconColor, size: 22),
                ),

                const SizedBox(width: 14),

                // Phone number + type
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.phoneNumber,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          entry.callType,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Delete button
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline,
                      color: Colors.redAccent, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),

            const SizedBox(height: 10),
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            const SizedBox(height: 8),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Dial button
                GestureDetector(
                  onTap: onDial,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C63FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.call, color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text(
                          "Dial",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Call History button
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'History for ${entry.phoneNumber}'),
                        backgroundColor: const Color(0xFF6C63FF),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE9FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.history,
                            color: Color(0xFF6C63FF), size: 14),
                        SizedBox(width: 4),
                        Text(
                          "History",
                          style: TextStyle(
                            color: Color(0xFF6C63FF),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}