import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:el_3mmary/core/providers/repository_providers.dart';
import 'package:el_3mmary/features/customers/presentation/providers/customer_providers.dart';
import 'package:el_3mmary/features/inspections/presentation/providers/inspection_providers.dart';
import 'package:el_3mmary/features/contracts/presentation/providers/contract_providers.dart';

class AddContractScreen extends ConsumerStatefulWidget {
  const AddContractScreen({super.key, this.preselectedCustomerId});

  /// When navigating from a customer details screen, the customer is already known.
  final String? preselectedCustomerId;

  @override
  ConsumerState<AddContractScreen> createState() => _AddContractScreenState();
}

class _AddContractScreenState extends ConsumerState<AddContractScreen> {
  final TextEditingController _pickupAddressController = TextEditingController();
  final TextEditingController _deliveryAddressController = TextEditingController();
  
  DateTime? _pickupDate;
  DateTime? _deliveryDate;
  String? _selectedCustomerId;
  String? _selectedInspectionId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedCustomerId = widget.preselectedCustomerId;
  }

  Future<void> _submit() async {
    if (_selectedCustomerId == null || _selectedInspectionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء اختيار العميل والمعاينة')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(contractRepositoryProvider).create(
        customerId: _selectedCustomerId!,
        inspectionId: _selectedInspectionId!,
        pickupAddress: _pickupAddressController.text.isNotEmpty ? _pickupAddressController.text : null,
        deliveryAddress: _deliveryAddressController.text.isNotEmpty ? _deliveryAddressController.text : null,
        pickupDate: _pickupDate,
        deliveryDate: _deliveryDate,
      );

      ref.invalidate(contractsProvider);
      ref.invalidate(customerContractsProvider(_selectedCustomerId!));

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت إضافة العقد بنجاح')));
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
    const Color primaryColor = Color(0xFF7D562D);
    const Color backgroundColor = Color(0xFFFDF9F5);
    const Color inputBackground = Color(0xFFF1EDE9);

    final customersAsyncValue = ref.watch(customersProvider);
    // Filter inspections by customer when a customer is selected
    final inspectionsAsyncValue = _selectedCustomerId != null
        ? ref.watch(customerInspectionsProvider(_selectedCustomerId!))
        : ref.watch(inspectionsProvider);
    final bool hasPreselectedCustomer = widget.preselectedCustomerId != null;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('إضافة عقد جديد'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFieldGroup(Icons.person, 'العميل', 
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
                        onChanged: (val) => setState(() {
                          _selectedCustomerId = val;
                          _selectedInspectionId = null; // Reset inspection when customer changes
                        }),
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (err, _) => Text('خطأ: $err'),
                  )
                ),
                const SizedBox(height: 16),
                _buildFieldGroup(Icons.visibility, 'المعاينة', 
                  inspectionsAsyncValue.when(
                    data: (inspections) {
                      if (inspections.isEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: inputBackground,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'لا توجد معاينات لهذا العميل',
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }
                      return DropdownButtonFormField<String>(
                        value: _selectedInspectionId,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: inputBackground,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                        hint: const Text('اختر المعاينة'),
                        items: inspections.map((i) => DropdownMenuItem(value: i.id, child: Text('معاينة ${i.address}'))).toList(),
                        onChanged: (val) => setState(() => _selectedInspectionId = val),
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (err, _) => Text('خطأ: $err'),
                  )
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Divider(thickness: 1, color: Color(0xFFD4C4B7)),
                ),

                LayoutBuilder(builder: (context, constraints) {
                  bool isTablet = constraints.maxWidth > 600;
                  return Column(
                    children: [
                      _buildResponsiveRow(
                        isTablet: isTablet,
                        children: [
                          _buildFieldGroup(Icons.location_on, 'عنوان الاستلام', 
                            _buildTextField(_pickupAddressController, 'أدخل عنوان الاستلام...')),
                          _buildFieldGroup(Icons.local_shipping, 'عنوان التسليم', 
                            _buildTextField(_deliveryAddressController, 'أدخل عنوان التسليم...')),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      _buildResponsiveRow(
                        isTablet: isTablet,
                        children: [
                          _buildFieldGroup(Icons.calendar_today, 'تاريخ الاستلام', 
                            _buildDatePicker(
                              _pickupDate == null ? 'اختر التاريخ' : '${_pickupDate!.toLocal()}'.split(' ')[0],
                              () async {
                                DateTime? picked = await showDatePicker(
                                  context: context, initialDate: DateTime.now(),
                                  firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
                                if (picked != null) setState(() => _pickupDate = picked);
                              })),
                          _buildFieldGroup(Icons.event_available, 'تاريخ التسليم المتوقع', 
                            _buildDatePicker(
                              _deliveryDate == null ? 'اختر التاريخ' : '${_deliveryDate!.toLocal()}'.split(' ')[0],
                              () async {
                                DateTime? picked = await showDatePicker(
                                  context: context, initialDate: DateTime.now().add(const Duration(days: 7)),
                                  firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
                                if (picked != null) setState(() => _deliveryDate = picked);
                              })),
                        ],
                      ),
                    ],
                  );
                }),

                const SizedBox(height: 40),

                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submit,
                  icon: const Icon(Icons.save),
                  label: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('حفظ العقد', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ودجت لتقسيم الصفوف بشكل متجاوب
  Widget _buildResponsiveRow({required bool isTablet, required List<Widget> children}) {
    if (isTablet) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: children[0]),
          const SizedBox(width: 20),
          Expanded(child: children[1]),
        ],
      );
    }
    return Column(children: [children[0], const SizedBox(height: 24), children[1]]);
  }

  Widget _buildFieldGroup(IconData icon, String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: const Color(0xFF82756A)),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 8),
        field,
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF1EDE9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildDatePicker(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(color: const Color(0xFFF1EDE9), borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: const TextStyle(fontSize: 15)),
            const Icon(Icons.calendar_month, color: Color(0xFF82756A), size: 20),
          ],
        ),
      ),
    );
  }
}