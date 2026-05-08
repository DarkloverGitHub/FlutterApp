import 'package:flutter/material.dart';
import '../models/job_model.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class JobDetailScreen extends StatefulWidget {
  const JobDetailScreen({super.key});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  bool _isSaved = false;
  bool _hasApplied = false;
  bool _applying = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final job = ModalRoute.of(context)?.settings.arguments as Job;
    _loadStatus(job.id);
  }

  Future<void> _loadStatus(String jobId) async {
    final saved = await StorageService.isJobSaved(jobId);
    final applied = await StorageService.hasApplied(jobId);
    setState(() {
      _isSaved = saved;
      _hasApplied = applied;
    });
  }

  Future<void> _apply(String jobId) async {
    setState(() => _applying = true);
    await Future.delayed(const Duration(milliseconds: 900));
    await StorageService.applyForJob(jobId);
    if (!mounted) return;
    setState(() {
      _applying = false;
      _hasApplied = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Application submitted! 🎉'),
        backgroundColor: AppTheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final job = ModalRoute.of(context)?.settings.arguments as Job;

    return Scaffold(
      backgroundColor: AppTheme.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppTheme.white,
            foregroundColor: AppTheme.textDark,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () async {
                  await StorageService.toggleSavedJob(job.id);
                  final saved = await StorageService.isJobSaved(job.id);
                  setState(() => _isSaved = saved);
                },
                icon: Icon(
                  _isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  color: _isSaved ? AppTheme.primary : AppTheme.textGrey,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppTheme.primaryLight, AppTheme.white],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withOpacity(0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(job.logoEmoji,
                            style: const TextStyle(fontSize: 32)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    job.company,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.textGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Info chips
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _InfoChip(Icons.location_on_rounded, job.location),
                      _InfoChip(Icons.work_rounded, job.type),
                      _InfoChip(Icons.category_rounded, job.category),
                      _InfoChip(Icons.attach_money_rounded, job.salary),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Job Description',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    job.description,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppTheme.textGrey,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Requirements',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...[
                    '3+ years of relevant experience',
                    'Strong communication skills',
                    'Bachelor\'s degree or equivalent',
                    'Portfolio or GitHub profile',
                  ].map((r) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 6),
                              child: CircleAvatar(
                                  radius: 4, backgroundColor: AppTheme.primary),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(r,
                                  style: const TextStyle(
                                      fontSize: 15, color: AppTheme.textGrey, height: 1.5)),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
        decoration: BoxDecoration(
          color: AppTheme.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: (_hasApplied || _applying)
                ? null
                : () => _apply(job.id),
            style: ElevatedButton.styleFrom(
              backgroundColor: _hasApplied ? Colors.green : AppTheme.primary,
              disabledBackgroundColor:
                  _hasApplied ? Colors.green : AppTheme.primary.withOpacity(0.6),
            ),
            child: _applying
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.5),
                  )
                : Text(
                    _hasApplied ? '✓ Applied' : 'Apply Now',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
