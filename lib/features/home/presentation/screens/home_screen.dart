import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:el_3mmary/features/customers/presentation/providers/customer_providers.dart';
import 'package:el_3mmary/features/inspections/presentation/providers/inspection_providers.dart';
import 'package:el_3mmary/features/inspections/data/models/inspection.dart';
import 'package:el_3mmary/features/contracts/presentation/providers/contract_providers.dart';
import 'package:el_3mmary/features/contracts/data/models/contract.dart';

/// Maps English DB status values to Arabic display labels.
String _statusLabel(String dbStatus) {
  const map = {
    'scheduled': 'مجدولة',
    'done': 'مكتملة',
    'no_contract': 'لم يتم التعاقد',
    'active': 'نشط',
    'cancelled': 'ملغى',
  };
  return map[dbStatus] ?? dbStatus;
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const Color primaryColor = Color(0xFF7D562D);
    const Color primaryContainer = Color(0xFFD4A373);
    const Color backgroundColor = Color(0xFFFDF9F5);

    // Dynamic date using intl for Arabic formatting
    final now = DateTime.now();
    final dateFormatter = DateFormat.yMMMMd('ar');
    final formattedDate = dateFormatter.format(now);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('العماري'),
        centerTitle: false,
        actions: [
          Text(
            formattedDate,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: primaryColor),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(context, 'نظرة عامة', null, null),
                const SizedBox(height: 12),

                // قسم الإحصائيات المتجاوب
                LayoutBuilder(
                  builder: (context, constraints) {
                    final customersAsync = ref.watch(customersProvider);
                    final inspectionsAsync = ref.watch(inspectionsProvider);
                    final contractsAsync = ref.watch(contractsProvider);

                    final totalCustomers =
                        customersAsync.valueOrNull?.length.toString() ?? '...';
                    final totalInspections =
                        inspectionsAsync.valueOrNull?.length.toString() ??
                        '...';
                    final activeContracts =
                        contractsAsync.valueOrNull
                            ?.where((c) => c.status == 'active')
                            .length
                            .toString() ??
                        '...';
                    final completedContracts =
                        contractsAsync.valueOrNull
                            ?.where((c) => c.status == 'cancelled')
                            .length
                            .toString() ??
                        '...';

                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: constraints.maxWidth > 600 ? 4 : 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.5,
                      children: [
                        _buildStatCard(
                          totalCustomers,
                          'إجمالي العملاء',
                          Icons.group,
                          Colors.blue,
                        ),
                        _buildStatCard(
                          totalInspections,
                          'إجمالي المعاينات',
                          Icons.visibility,
                          Colors.orange,
                        ),
                        _buildStatCard(
                          activeContracts,
                          'عقود نشطة',
                          Icons.description,
                          primaryColor,
                        ),
                        _buildStatCard(
                          completedContracts,
                          'عقود ملغاة',
                          Icons.cancel_outlined,
                          Colors.red,
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 24),

                // توزيع المعاينات والعقود (بجانب بعض في التابلت)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final inspectionsAsync = ref.watch(inspectionsProvider);
                    final contractsAsync = ref.watch(contractsProvider);
                    final customerNamesAsync =
                        ref.watch(customerNameMapProvider);

                    if (constraints.maxWidth > 800) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildTodayInspections(
                              context,
                              primaryColor,
                              inspectionsAsync,
                              customerNamesAsync,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _buildActiveContracts(
                              context,
                              primaryColor,
                              contractsAsync,
                              customerNamesAsync,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          _buildTodayInspections(
                            context,
                            primaryColor,
                            inspectionsAsync,
                            customerNamesAsync,
                          ),
                          const SizedBox(height: 24),
                          _buildActiveContracts(
                            context,
                            primaryColor,
                            contractsAsync,
                            customerNamesAsync,
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: primaryContainer,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: primaryColor,
        onTap: (index) {
          if (index == 0)
            context.go('/');
          else if (index == 1)
            context.go('/customers');
          else if (index == 2)
            context.go('/contracts');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'العملاء'),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'العقود',
          ),
        ],
      ),
    );
  }

  // قسم معاينات اليوم
  Widget _buildTodayInspections(
    BuildContext context,
    Color primary,
    AsyncValue<List<Inspection>> inspectionsAsync,
    AsyncValue<Map<String, String>> customerNamesAsync,
  ) {
    return Column(
      children: [
        _buildSectionTitle(context, 'معاينات اليوم', 'عرض الكل', '/inspections'),
        const SizedBox(height: 12),
        inspectionsAsync.when(
          data: (inspections) {
            final now = DateTime.now();
            final todayStart = DateTime(now.year, now.month, now.day);
            final todayEnd = todayStart.add(const Duration(days: 1));

            // Filter only today's inspections
            final todayInspections = inspections.where((i) {
              if (i.scheduledFrom != null) {
                return i.scheduledFrom!.isAfter(todayStart) &&
                    i.scheduledFrom!.isBefore(todayEnd);
              }
              // Also include inspections created today if no schedule
              if (i.createdAt != null) {
                return i.createdAt!.isAfter(todayStart) &&
                    i.createdAt!.isBefore(todayEnd);
              }
              return false;
            }).toList();

            if (todayInspections.isEmpty) {
              return const Text('لا توجد معاينات اليوم.');
            }

            final nameMap = customerNamesAsync.valueOrNull ?? {};

            return Column(
              children: todayInspections
                  .take(3)
                  .map(
                    (i) => _buildInspectionItem(
                      nameMap[i.customerId] ?? 'عميل غير معروف',
                      i.scheduledFrom != null
                          ? '${i.scheduledFrom!.hour}:${i.scheduledFrom!.minute.toString().padLeft(2, '0')}'
                          : '',
                      _statusLabel(i.status),
                      i.address,
                      i.status == 'done' ? Colors.green : Colors.orange,
                    ),
                  )
                  .toList(),
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (e, _) => Text('خطأ: $e'),
        ),
      ],
    );
  }

  // قسم العقود النشطة
  Widget _buildActiveContracts(
    BuildContext context,
    Color primary,
    AsyncValue<List<Contract>> contractsAsync,
    AsyncValue<Map<String, String>> customerNamesAsync,
  ) {
    return Column(
      children: [
        _buildSectionTitle(context, 'عقود نشطة', 'عرض الكل', '/contracts'),
        const SizedBox(height: 12),
        contractsAsync.when(
          data: (contracts) {
            final active = contracts
                .where((c) => c.status == 'active')
                .toList();
            if (active.isEmpty) return const Text('لا توجد عقود نشطة.');

            final nameMap = customerNamesAsync.valueOrNull ?? {};

            return Column(
              children: active
                  .take(2)
                  .map(
                    (c) => _buildContractItem(
                      'عقد #${c.id.substring(0, 4)}',
                      _statusLabel(c.status),
                      nameMap[c.customerId] ?? 'عميل غير معروف',
                      'الاستلام ${c.deliveryDate != null ? c.deliveryDate!.toString().split(' ')[0] : 'غير محدد'}',
                      c.status == 'active' ? primary : Colors.red,
                    ),
                  )
                  .toList(),
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (e, _) => Text('خطأ: $e'),
        ),
      ],
    );
  }

  // ودجت كارت الإحصائيات
  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  // ودجت عنوان القسم
  Widget _buildSectionTitle(BuildContext context, String title, String? actionText, String? route) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (actionText != null)
          TextButton(
            onPressed: route != null ? () => context.push(route) : null,
            child: Text(
              actionText,
              style: const TextStyle(color: Color(0xFFD4A373)),
            ),
          ),
      ],
    );
  }

  // كارت معاينة
  Widget _buildInspectionItem(
    String name,
    String time,
    String status,
    String loc,
    Color statusColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.schedule, size: 14, color: Colors.grey.shade400),
              const SizedBox(width: 4),
              Text(
                time,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              Icon(Icons.location_on, size: 14, color: Colors.grey.shade400),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  loc,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // كارت عقد
  Widget _buildContractItem(
    String id,
    String status,
    String customer,
    String date,
    Color statusColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                id,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7D562D),
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.person, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(customer, style: const TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                date,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
