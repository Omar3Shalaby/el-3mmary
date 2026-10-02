import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:el_3mmary/core/providers/repository_providers.dart';
import 'package:el_3mmary/features/inspections/data/models/inspection.dart';
import 'package:el_3mmary/features/inspections/data/models/inspection_item.dart';
import 'package:el_3mmary/features/customers/presentation/providers/customer_providers.dart';

/// Provider to fetch a single inspection by ID.
final inspectionDetailsProvider =
    FutureProvider.family<Inspection, String>((ref, id) async {
  final data = await ref
      .watch(inspectionRepositoryProvider)
      .getAll(); // ideally add a getById
  return data.firstWhere((i) => i.id == id);
});

/// Provider to fetch inspection items.
final inspectionItemsProvider =
    FutureProvider.family<List<InspectionItem>, String>((ref, inspectionId) async {
  return ref.watch(inspectionRepositoryProvider).getItems(inspectionId);
});

class InspectionDetailsScreen extends ConsumerWidget {
  const InspectionDetailsScreen({super.key, required this.inspectionId});

  final String inspectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const Color backgroundColor = Color(0xFFFDF9F5);

    final inspectionAsync = ref.watch(inspectionDetailsProvider(inspectionId));
    final itemsAsync = ref.watch(inspectionItemsProvider(inspectionId));

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('تفاصيل المعاينة'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: inspectionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطأ: $e')),
        data: (inspection) {
          final customerAsync =
              ref.watch(customerDetailsProvider(inspection.customerId));

          return LayoutBuilder(
            builder: (context, constraints) {
              bool isTablet = constraints.maxWidth > 800;

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: isTablet
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: _buildInfoSide(
                                context,
                                inspection,
                                customerAsync,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: _buildItemsSide(context, itemsAsync),
                            ),
                          ],
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildInfoSide(
                                context,
                                inspection,
                                customerAsync,
                              ),
                              _buildItemsSide(context, itemsAsync),
                            ],
                          ),
                        ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  String _statusLabel(String dbStatus) {
    const map = {
      'scheduled': 'قيد الإنتظار',
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

  // الجزء الخاص بمعلومات العميل والمعاينة
  Widget _buildInfoSide(
    BuildContext context,
    Inspection inspection,
    AsyncValue customerAsync,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // كارت رأس العميل
          _buildCard(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundColor: Color(0xFFE6E2DE),
                  child: Icon(Icons.person, size: 40, color: Color(0xFF7D562D)),
                ),
                const SizedBox(height: 12),
                customerAsync.when(
                  data: (customer) => Text(
                    customer.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  loading: () => const Text('...'),
                  error: (_, _) => const Text('خطأ'),
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.calendar_today,
                  inspection.createdAt != null
                      ? '${inspection.createdAt!.year}-${inspection.createdAt!.month}-${inspection.createdAt!.day}'
                      : 'غير محدد',
                ),
                const SizedBox(height: 8),
                _buildStatusBadge(
                  _statusLabel(inspection.status),
                  _statusColor(inspection.status),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // كارت التفاصيل المكانية
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(Icons.location_on, 'العنوان'),
                Text(inspection.address,
                    style: const TextStyle(color: Colors.grey)),
                const Divider(height: 32),
                _buildSectionHeader(Icons.schedule, 'الوقت'),
                Text(
                  inspection.scheduledFrom != null && inspection.scheduledTo != null
                      ? '${inspection.scheduledFrom!.hour}:${inspection.scheduledFrom!.minute.toString().padLeft(2, '0')} - ${inspection.scheduledTo!.hour}:${inspection.scheduledTo!.minute.toString().padLeft(2, '0')}'
                      : inspection.scheduledFrom != null
                          ? '${inspection.scheduledFrom!.hour}:${inspection.scheduledFrom!.minute.toString().padLeft(2, '0')}'
                          : 'غير محدد',
                  style: const TextStyle(color: Colors.grey),
                ),
                if (inspection.notes != null &&
                    inspection.notes!.isNotEmpty) ...[
                  const Divider(height: 32),
                  _buildSectionHeader(Icons.note, 'ملاحظات العميل'),
                  Text(inspection.notes!,
                      style: const TextStyle(color: Colors.grey)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // الجزء الخاص بقطع العفش والتسعير
  Widget _buildItemsSide(
      BuildContext context, AsyncValue<List<InspectionItem>> itemsAsync) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطأ: $e')),
        data: (items) {
          final total = items.fold<double>(
              0, (sum, item) => sum + (item.price * item.quantity));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'قطع العفش (${items.length} قطعة)',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, color: Color(0xFFD4A373)),
                    label: const Text('إضافة قطعة',
                        style: TextStyle(color: Color(0xFFD4A373))),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (items.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('لا توجد قطع مسجلة لهذه المعاينة.',
                        style: TextStyle(color: Colors.grey)),
                  ),
                )
              else
                ...items.map((item) => _buildFurnitureItem(
                      title: item.itemName,
                      qty: 'x${item.quantity}',
                      desc: item.description ?? '',
                      price: '${item.price.toStringAsFixed(0)} جنيه',
                    )),
              const SizedBox(height: 24),
              _buildTotalSection(total),
            ],
          );
        },
      ),
    );
  }

  // كارت قطعة عفش واحدة
  Widget _buildFurnitureItem({
    required String title,
    required String qty,
    required String desc,
    required String price,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // أيقونة بدلاً من صورة placeholder
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFD4A373).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.chair, size: 40, color: Color(0xFFD4A373)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(qty,
                        style: const TextStyle(
                            color: Color(0xFFD4A373),
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                if (desc.isNotEmpty)
                  Text(desc,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(price,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7D562D))),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.edit,
                                size: 20, color: Colors.blue)),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.delete,
                                size: 20, color: Colors.red)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSection(double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: const Color(0xFFD4A373).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('الإجمالي:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(
            '${total.toStringAsFixed(0)} جنيه',
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7D562D)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -2))
          ]),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4A373),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('تحويل إلى عقد',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('لم يتم التعاقد'),
            ),
          ),
        ],
      ),
    );
  }

  // مساعدات التصميم (Helper Widgets)
  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)
          ]),
      child: child,
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(color: Colors.grey))
        ]);
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20)),
        child: Text(text,
            style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold)));
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(children: [
      Icon(icon, size: 18, color: const Color(0xFFD4A373)),
      const SizedBox(width: 8),
      Text(title, style: const TextStyle(fontWeight: FontWeight.bold))
    ]);
  }
}