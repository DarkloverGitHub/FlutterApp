import 'package:flutter/material.dart';
import '../models/job_model.dart';
import '../theme/app_theme.dart';
import '../widgets/job_card.dart';

class SavedJobsScreen extends StatelessWidget {
  final List<String> savedIds;
  final Future<void> Function(String) onToggle;

  const SavedJobsScreen({
    super.key,
    required this.savedIds,
    required this.onToggle,
  });

  List<Job> get _savedJobs =>
      sampleJobs.where((j) => savedIds.contains(j.id)).toList();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Text(
              'Saved Jobs',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppTheme.textDark,
              ),
            ),
          ),
          Expanded(
            child: _savedJobs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🔖', style: TextStyle(fontSize: 56)),
                        const SizedBox(height: 16),
                        const Text(
                          'No saved jobs yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Bookmark jobs you like to\nreview them later',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppTheme.textGrey, height: 1.5),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _savedJobs.length,
                    itemBuilder: (_, i) {
                      final job = _savedJobs[i];
                      return JobCard(
                        job: job,
                        isSaved: true,
                        onSave: () => onToggle(job.id),
                        onTap: () => Navigator.pushNamed(
                            context, '/job-detail', arguments: job),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
