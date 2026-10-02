import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:el_3mmary/features/customers/presentation/providers/customer_providers.dart';
import 'package:el_3mmary/features/inspections/presentation/providers/inspection_providers.dart';
import 'package:el_3mmary/features/contracts/presentation/providers/contract_providers.dart';

class CustomerDetailsScreen extends ConsumerWidget {
  const CustomerDetailsScreen({super.key, required this.customerId});

  final String customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const Color primaryColor = Color(0xFF7D562D);
    const Color primaryContainer = Color(0xFFD4A373);
    const Color backgroundColor = Color(0xFFFDF9F5);

    final customerAsync = ref.watch(customerDetailsProvider(customerId));
    final inspectionsAsync = ref.watch(customerInspectionsProvider(customerId));
    final contractsAsync = ref.watch(customerContractsProvider(customerId));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(title: const Text('ملف العميل')),
        body: customerAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('خطأ: $e')),
          data: (customer) => Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                children: [
                  // رأس الملف (معلومات العميل)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: Color(0xFFE6E2DE),
                          child: Icon(Icons.person, size: 50, color: primaryColor),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          customer.name,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        if (customer.phones.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              customer.phones.first,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const TabBar(
                    labelColor: primaryColor,
                    indicatorColor: primaryColor,
                    tabs: [Tab(text: 'المعاينات'), Tab(text: 'العقود')],
                  ),

                  Expanded(
                    child: TabBarView(
                      children: [
                        // تبويب المعاينات
                        inspectionsAsync.when(
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (e, _) => Center(child: Text('خطأ: $e')),
                          data: (inspections) {
                            if (inspections.isEmpty) {
                              return const Center(child: Text('لا توجد معاينات لهذا العميل.'));
                            }
                            return LayoutBuilder(builder: (context, constraints) {
                              int crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;
                              return GridView.builder(
                                padding: const EdgeInsets.all(16),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  mainAxisExtent: 180,
                                ),
                                itemCount: inspections.length,
                                itemBuilder: (context, index) {
                                  final insp = inspections[index];
                                  return InkWell(
                                    onTap: () => context.push('/inspections/${insp.id}'),
                                    child: _buildInspectionCard(
                                      date: insp.scheduledFrom != null
                                          ? '${insp.scheduledFrom!.year}-${insp.scheduledFrom!.month.toString().padLeft(2, '0')}-${insp.scheduledFrom!.day.toString().padLeft(2, '0')}'
                                          : 'غير محدد',
                                      status: _statusLabel(insp.status),
                                      statusColor: insp.status == 'done' ? Colors.green : Colors.orange,
                                      address: insp.address,
                                      notes: insp.notes ?? '',
                                    ),
                                  );
                                },
                              );
                            });
                          },
                        ),
                        // تبويب العقود
                        contractsAsync.when(
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (e, _) => Center(child: Text('خطأ: $e')),
                          data: (contracts) {
                            if (contracts.isEmpty) {
                              return const Center(child: Text('لا توجد عقود لهذا العميل.'));
                            }
                            return ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: contracts.length,
                              itemBuilder: (context, index) {
                                final c = contracts[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.05),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'عقد #${c.id.substring(0, 4)}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: primaryColor,
                                            ),
                                          ),
                                          Text(
                                            _statusLabel(c.status),
                                            style: TextStyle(
                                              color: c.status == 'active' ? Colors.green : Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      if (c.deliveryDate != null)
                                        Text(
                                          'التسليم: ${c.deliveryDate!.toString().split(' ')[0]}',
                                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                                        ),
                                      if (c.pickupDate != null)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4),
                                          child: Text(
                                            'الاستلام: ${c.pickupDate!.toString().split(' ')[0]}',
                                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // أزرار إضافة معاينة وعقد
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => context.push('/inspections/add?customerId=$customerId'),
                            icon: const Icon(Icons.visibility, size: 20),
                            label: const Text('إضافة معاينة'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryContainer,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => context.push('/contracts/add?customerId=$customerId'),
                            icon: const Icon(Icons.description, size: 20),
                            label: const Text('إضافة عقد'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInspectionCard({
    required String date,
    required String status,
    required Color statusColor,
    required String address,
    required String notes,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Text(address, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          if (notes.isNotEmpty)
            Text(notes, style: const TextStyle(fontSize: 13, color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis),
          const Spacer(),
          const Center(child: Text('التفاصيل', style: TextStyle(color: Color(0xFF7D562D), fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

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
}