import 'package:flutter/material.dart';
import '../models/job_model.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/job_card.dart';
import 'saved_jobs_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _userName = '';
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All', 'Technology', 'Design', 'Management', 'Data', 'Marketing'
  ];
  List<Job> _jobs = List.from(sampleJobs);
  List<String> _savedIds = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final name = await StorageService.getUserName();
    final saved = await StorageService.getSavedJobIds();
    setState(() {
      _userName = name;
      _savedIds = saved;
    });
  }

  List<Job> get _filteredJobs {
    if (_selectedCategory == 'All') return _jobs;
    return _jobs
        .where((j) => j.category == _selectedCategory)
        .toList();
  }

  Future<void> _toggleSave(String jobId) async {
    await StorageService.toggleSavedJob(jobId);
    final saved = await StorageService.getSavedJobIds();
    setState(() => _savedIds = saved);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildDashboard(),
      SavedJobsScreen(savedIds: _savedIds, onToggle: _toggleSave),
      ProfileScreen(onUpdate: _loadData),
      SettingsScreen(onLogout: () {
        StorageService.logout();
        Navigator.pushReplacementNamed(context, '/welcome');
      }),
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppTheme.white,
          boxShadow: [
            BoxShadow(color: Color(0x0F000000), blurRadius: 20, offset: Offset(0, -4)),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppTheme.primary,
          unselectedItemColor: AppTheme.textGrey,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark_rounded), label: 'Saved'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
            BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Settings'),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard() {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, ${_userName.isNotEmpty ? _capitalize(_userName) : "there"} 👋',
                              style: const TextStyle(
                                color: AppTheme.textGrey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Find Your Dream Job',
                              style: TextStyle(
                                color: AppTheme.textDark,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text('💼', style: TextStyle(fontSize: 20)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Search Bar
                  Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        const Icon(Icons.search_rounded, color: AppTheme.textGrey),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Search job, company...',
                            style: TextStyle(color: AppTheme.textGrey, fontSize: 15),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(6),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.tune_rounded,
                              color: Colors.white, size: 18),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Stats row
                  Row(
                    children: [
                      _StatCard(value: '${sampleJobs.length}', label: 'Jobs Available'),
                      const SizedBox(width: 12),
                      _StatCard(value: _savedIds.length.toString(), label: 'Saved Jobs'),
                      const SizedBox(width: 12),
                      const _StatCard(value: '12', label: 'Companies'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Category chips
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          // Category scroll
          SliverToBoxAdapter(
            child: SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final cat = _categories[i];
                  final selected = cat == _selectedCategory;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? AppTheme.primary : AppTheme.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected ? AppTheme.primary : AppTheme.border,
                        ),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: selected ? Colors.white : AppTheme.textGrey,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_filteredJobs.length} Jobs Found',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  Text(
                    'Sort by: Recent',
                    style: const TextStyle(
                        color: AppTheme.primary, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          // Job list
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) {
                  final job = _filteredJobs[i];
                  return JobCard(
                    job: job,
                    isSaved: _savedIds.contains(job.id),
                    onSave: () => _toggleSave(job.id),
                    onTap: () => Navigator.pushNamed(
                        context, '/job-detail', arguments: job),
                  );
                },
                childCount: _filteredJobs.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: AppTheme.textGrey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
