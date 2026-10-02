import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:el_3mmary/features/inspections/presentation/providers/inspection_providers.dart';
import 'package:el_3mmary/features/customers/presentation/providers/customer_providers.dart';

/// Maps Arabic filter labels to English DB status values.
const _filterToDbStatus = {
  'الكل': null,
  'مجدولة': 'scheduled',
  'مكتملة': 'done',
  'لم يتم التعاقد': 'no_contract',
};

/// Maps English DB status values to Arabic display labels.
String _statusLabel(String dbStatus) {
  const map = {
    'scheduled': 'مجدولة',
    'done': 'مكتملة',
    'no_contract': 'لم يتم التعاقد',
  };
  return map[dbStatus] ?? dbStatus;
}

Color _statusColor(String dbStatus) {
  switch (dbStatus) {
    case 'done':
      return Colors.green;
    case 'no_contract':
      return Colors.red;
    default:
      return Colors.orange;
  }
}

class InspectionsListScreen extends ConsumerStatefulWidget {
  const InspectionsListScreen({super.key});

  @override
  ConsumerState<InspectionsListScreen> createState() => _InspectionsListScreenState();
}

class _InspectionsListScreenState extends ConsumerState<InspectionsListScreen> {
  String selectedFilter = 'الكل';
  final List<String> filters = ['الكل', 'مجدولة', 'مكتملة', 'لم يتم التعاقد'];

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF7D562D);
    const Color backgroundColor = Color(0xFFF5F1ED);

    final customerNamesAsync = ref.watch(customerNameMapProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('جدول المعاينات'),
        actions: [
          IconButton(icon: const Icon(Icons.calendar_month, color: primaryColor), onPressed: () {}),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              // فلاتر الحالات
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: filters.length,
                  itemBuilder: (context, index) {
                    bool isSelected = selectedFilter == filters[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(filters[index]),
                        selected: isSelected,
                        onSelected: (val) => setState(() => selectedFilter = filters[index]),
                        selectedColor: const Color(0xFFD4A373),
                        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                      ),
                    );
                  },
                ),
              ),

              // القائمة المتجاوبة
              Expanded(
                child: ref.watch(inspectionsProvider).when(
                  data: (inspections) {
                    // Apply filter
                    final dbStatus = _filterToDbStatus[selectedFilter];
                    final filtered = dbStatus == null
                        ? inspections
                        : inspections.where((i) => i.status == dbStatus).toList();

                    if (filtered.isEmpty) {
                      return const Center(child: Text('لا توجد معاينات.'));
                    }

                    final nameMap = customerNamesAsync.valueOrNull ?? {};

                    return LayoutBuilder(builder: (context, constraints) {
                      int crossAxisCount = constraints.maxWidth > 700 ? 2 : 1;
                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          mainAxisExtent: 160,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final inspection = filtered[index];
                          return InkWell(
                            onTap: () => context.push('/inspections/${inspection.id}'),
                            child: _buildInspectionCard(
                              customerName: nameMap[inspection.customerId] ?? 'عميل غير معروف',
                              time: inspection.scheduledFrom != null 
                                ? '${inspection.scheduledFrom!.hour}:${inspection.scheduledFrom!.minute.toString().padLeft(2, '0')}'
                                : 'غير محدد',
                              date: inspection.scheduledFrom != null 
                                ? '${inspection.scheduledFrom!.year}-${inspection.scheduledFrom!.month.toString().padLeft(2, '0')}-${inspection.scheduledFrom!.day.toString().padLeft(2, '0')}' 
                                : 'غير محدد',
                              address: inspection.address,
                              status: _statusLabel(inspection.status),
                              statusColor: _statusColor(inspection.status),
                            ),
                          );
                        },
                      );
                    });
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('خطأ: $err')),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/inspections/add'),
        backgroundColor: const Color(0xFFD4A373),
        child: const Icon(Icons.add_location_alt_outlined, color: Colors.white),
      ),
    );
  }

  Widget _buildInspectionCard({
    required String customerName,
    required String time,
    required String date,
    required String address,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(customerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), overflow: TextOverflow.ellipsis),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildIconText(Icons.calendar_today, date),
          const SizedBox(height: 4),
          _buildIconText(Icons.schedule, time),
          const SizedBox(height: 4),
          _buildIconText(Icons.location_on, address, isEllipsis: true),
          const Spacer(),
          const Align(
            alignment: Alignment.centerLeft,
            child: Icon(Icons.arrow_back, size: 18, color: Color(0xFF7D562D)),
          )
        ],
      ),
    );
  }

  Widget _buildIconText(IconData icon, String text, {bool isEllipsis = false}) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            overflow: isEllipsis ? TextOverflow.ellipsis : null,
          ),
        ),
      ],
    );
  }
}