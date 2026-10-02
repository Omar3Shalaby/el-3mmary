import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:el_3mmary/core/providers/repository_providers.dart';
import 'package:el_3mmary/features/customers/presentation/providers/customer_providers.dart';
import 'package:el_3mmary/features/inspections/presentation/providers/inspection_providers.dart';

class AddInspectionScreen extends ConsumerStatefulWidget {
  const AddInspectionScreen({super.key, this.preselectedCustomerId});

  /// When navigating from a customer details screen, the customer is already known.
  final String? preselectedCustomerId;

  @override
  ConsumerState<AddInspectionScreen> createState() => _AddInspectionScreenState();
}

class _AddInspectionScreenState extends ConsumerState<AddInspectionScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _selectedCustomerId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedCustomerId = widget.preselectedCustomerId;
  }

  Future<void> _submit() async {
    if (_selectedCustomerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء اختيار العميل')));
      return;
    }
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء إدخال العنوان')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      DateTime? scheduledFrom;
      DateTime? scheduledTo;

      if (_selectedDate != null) {
        if (_startTime != null) {
          scheduledFrom = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day, _startTime!.hour, _startTime!.minute);
        } else {
          scheduledFrom = _selectedDate;
        }

        if (_endTime != null) {
          scheduledTo = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day, _endTime!.hour, _endTime!.minute);
        }
      }

      await ref.read(inspectionRepositoryProvider).create(
        customerId: _selectedCustomerId!,
        address: _addressController.text,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        scheduledFrom: scheduledFrom,
        scheduledTo: scheduledTo,
      );

      ref.invalidate(inspectionsProvider);
      // Also invalidate the customer-specific inspections provider
      ref.invalidate(customerInspectionsProvider(_selectedCustomerId!));
      
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت إضافة المعاينة بنجاح')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryContainer = Color(0xFFD4A373);
    const Color backgroundColor = Color(0xFFFDF9F5);
    const Color inputBackground = Color(0xFFF1EDE9);

    final customersAsyncValue = ref.watch(customersProvider);
    final bool hasPreselectedCustomer = widget.preselectedCustomerId != null;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('معاينة جديدة'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(Icons.person, 'العميل المرتبط'),
                customersAsyncValue.when(
                  data: (customers) {
                    if (hasPreselectedCustomer) {
                      // Show the customer name as read-only
                      final customer = customers.where((c) => c.id == widget.preselectedCustomerId).toList();
                      final customerName = customer.isNotEmpty ? customer.first.name : 'عميل غير معروف';
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: inputBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.person, color: Color(0xFF82756A), size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                customerName,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                            const Icon(Icons.lock_outline, color: Colors.grey, size: 18),
                          ],
                        ),
                      );
                    }
                    return DropdownButtonFormField<String>(
                      value: _selectedCustomerId,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: inputBackground,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                      hint: const Text('اختر العميل'),
                      items: customers.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                      onChanged: (val) => setState(() => _selectedCustomerId = val),
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (err, _) => Text('خطأ في تحميل العملاء: $err'),
                ),
                const SizedBox(height: 24),

                _buildSectionHeader(Icons.location_on, 'عنوان المعاينة'),
                _buildTextField(
                  controller: _addressController,
                  hint: 'أدخل تفاصيل العنوان...',
                ),
                const SizedBox(height: 24),

                _buildSectionHeader(Icons.calendar_today, 'تاريخ المعاينة'),
                _buildPickerField(
                  text: _selectedDate == null 
                      ? 'اختر التاريخ' 
                      : '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) setState(() => _selectedDate = picked);
                  },
                ),
                const SizedBox(height: 24),

                LayoutBuilder(builder: (context, constraints) {
                  bool isTablet = constraints.maxWidth > 600;
                  return Flex(
                    direction: isTablet ? Axis.horizontal : Axis.vertical,
                    children: [
                      Flexible(
                        flex: isTablet ? 1 : 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionHeader(Icons.schedule, 'وقت البدء'),
                            _buildPickerField(
                              text: _startTime == null ? '00:00' : _startTime!.format(context),
                              onTap: () async {
                                TimeOfDay? picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                                if (picked != null) setState(() => _startTime = picked);
                              },
                            ),
                            if (!isTablet) const SizedBox(height: 24),
                          ],
                        ),
                      ),
                      if (isTablet) const SizedBox(width: 16),
                      Flexible(
                        flex: isTablet ? 1 : 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionHeader(Icons.update, 'وقت الانتهاء (تقريبي)'),
                            _buildPickerField(
                              text: _endTime == null ? '00:00' : _endTime!.format(context),
                              onTap: () async {
                                TimeOfDay? picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                                if (picked != null) setState(() => _endTime = picked);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 24),

                _buildSectionHeader(Icons.notes, 'ملاحظات إضافية (اختياري)'),
                _buildTextField(
                  controller: _notesController,
                  hint: 'أضف أي ملاحظات تهم المندوب...',
                  maxLines: 4,
                ),
                const SizedBox(height: 40),

                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submit,
                  icon: const Icon(Icons.save),
                  label: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('حفظ المعاينة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryContainer,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ودجت لعنوان كل قسم مع الأيقونة
  Widget _buildSectionHeader(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF82756A)),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  // ودجت للحقول النصية
  Widget _buildTextField({required TextEditingController controller, required String hint, int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF1EDE9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD4A373), width: 1.5),
        ),
      ),
    );
  }

  // ودجت لحقول الاختيار (التاريخ والوقت)
  Widget _buildPickerField({required String text, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF1EDE9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: const TextStyle(fontSize: 16)),
            const Icon(Icons.arrow_drop_down, color: Color(0xFF82756A)),
          ],
        ),
      ),
    );
  }
}