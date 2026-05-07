import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:el_3mmary/core/providers/supabase_providers.dart';
import 'package:el_3mmary/core/theme/app_theme.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('العماري'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'تسجيل الخروج',
            onPressed: () async {
              await ref.read(supabaseServiceProvider).signOut();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _DashboardCard(
              icon: Icons.people_outline,
              label: 'العملاء',
              color: AppTheme.primary,
              onTap: () {
                // TODO: navigate to customers
              },
            ),
            _DashboardCard(
              icon: Icons.search_rounded,
              label: 'المعاينات',
              color: AppTheme.primaryDark,
              onTap: () {
                // TODO: navigate to inspections
              },
            ),
            _DashboardCard(
              icon: Icons.description_outlined,
              label: 'العقود',
              color: Colors.black87,
              onTap: () {
                // TODO: navigate to contracts
              },
            ),
            _DashboardCard(
              icon: Icons.settings_outlined,
              label: 'الإعدادات',
              color: Colors.black54,
              onTap: () {
                // TODO: navigate to settings
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
