import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:el_3mmary/features/contracts/presentation/providers/contract_providers.dart';
import 'package:el_3mmary/features/customers/presentation/providers/customer_providers.dart';

/// Maps Arabic filter labels to English DB status values.
const _filterToDbStatus = {
  'الكل': null,
  'نشطة': 'active',
  'ملغاة': 'cancelled',
};

/// Maps English DB status values to Arabic display labels.
String _statusLabel(String dbStatus) {
  const map = {
    'active': 'نشط',
    'cancelled': 'ملغى',
  };
  return map[dbStatus] ?? dbStatus;
}

Color _statusColor(String dbStatus) {
  switch (dbStatus) {
    case 'active':
      return Colors.green;
    case 'cancelled':
      return Colors.red;
    default:
      return Colors.orange;
  }
}

class ContractsListScreen extends ConsumerStatefulWidget {
  const ContractsListScreen({super.key});

  @override
  ConsumerState<ContractsListScreen> createState() => _ContractsListScreenState();
}

class _ContractsListScreenState extends ConsumerState<ContractsListScreen> {
  // حالة الفلتر المختار
  String selectedFilter = 'الكل';
  final List<String> filters = ['الكل', 'نشطة', 'ملغاة'];

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF7D562D);
    const Color backgroundColor = Color(0xFFF5F1ED); // اللون المفضل لديك للخلفية

    final customerNamesAsync = ref.watch(customerNameMapProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('العقود'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: primaryColor),
            onPressed: () {},
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFE6E2DE),
              child: Icon(Icons.person, size: 20, color: primaryColor),
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // نص وصفي للشاشة
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Text(
                  'إدارة وتتبع جميع العقود الحالية والسابقة.',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),

              // شريط الفلترة (Filter Chips)
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: filters.length,
                  itemBuilder: (context, index) {
                    bool isSelected = selectedFilter == filters[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChip(
                        label: Text(filters[index]),
                        selected: isSelected,
                        onSelected: (val) => setState(() => selectedFilter = filters[index]),
                        selectedColor: const Color(0xFFD4A373),
                        checkmarkColor: Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // قائمة العقود المتجاوبة
              Expanded(
                child: ref.watch(contractsProvider).when(
                  data: (contracts) {
                    // Apply filter
                    final dbStatus = _filterToDbStatus[selectedFilter];
                    final filtered = dbStatus == null
                        ? contracts
                        : contracts.where((c) => c.status == dbStatus).toList();

                    if (filtered.isEmpty) {
                      return const Center(child: Text('لا توجد عقود.'));
                    }

                    final nameMap = customerNamesAsync.valueOrNull ?? {};

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount = constraints.maxWidth > 700 ? 2 : 1;
                        return GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            mainAxisExtent: 210, // ارتفاع الكارت
                          ),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final contract = filtered[index];
                            return _buildContractCard(
                              customerName: nameMap[contract.customerId] ?? 'عميل غير معروف',
                              description: 'تاريخ الإنشاء: ${contract.createdAt?.toLocal().toString().split(' ')[0] ?? 'غير محدد'}',
                              status: contract.status,
                              pickupDate: contract.pickupDate?.toString().split(' ')[0],
                              deliveryDate: contract.deliveryDate?.toString().split(' ')[0],
                            );
                          },
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('خطأ: $err')),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // تبويب العقود
        selectedItemColor: primaryColor,
        onTap: (index) {
          if (index == 0) context.go('/');
          else if (index == 1) context.go('/customers');
          else if (index == 2) context.go('/contracts');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'العملاء'),
          BottomNavigationBarItem(icon: Icon(Icons.description), label: 'العقود'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/contracts/add'),
        backgroundColor: const Color(0xFFD4A373),
        child: const Icon(Icons.add_card, color: Colors.white),
      ),
    );
  }

  Widget _buildContractCard({
    required String customerName,
    required String description,
    required String status,
    String? pickupDate,
    String? deliveryDate,
  }) {
    final color = _statusColor(status);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(customerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17), overflow: TextOverflow.ellipsis),
              ),
              _buildStatusBadge(_statusLabel(status), color),
            ],
          ),
          const SizedBox(height: 4),
          Text(description, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const Divider(height: 24),
          _buildDateRow(
            Icons.calendar_today,
            'تاريخ الاستلام:',
            pickupDate ?? 'غير محدد',
          ),
          const SizedBox(height: 4),
          _buildDateRow(
            Icons.event_available,
            'تاريخ التسليم:',
            deliveryDate ?? 'غير محدد',
          ),
          const Spacer(),
          // زر الأكشن في أسفل الكارت
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.visibility, size: 18, color: const Color(0xFF7D562D)),
              const SizedBox(width: 8),
              const Text(
                'عرض التفاصيل',
                style: TextStyle(color: Color(0xFF7D562D), fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateRow(IconData icon, String label, String date) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(width: 4),
        Text(date, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}