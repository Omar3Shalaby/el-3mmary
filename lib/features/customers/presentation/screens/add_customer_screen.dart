import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:el_3mmary/core/providers/repository_providers.dart';
import 'package:el_3mmary/features/customers/presentation/providers/customer_providers.dart';

class AddCustomerScreen extends ConsumerStatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  ConsumerState<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends ConsumerState<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _phone = '';
  bool _isLoading = false;

  /// Validates Egyptian phone numbers: must be 11 digits starting with 01.
  String? _validateEgyptianPhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // phone is optional
    }
    final cleaned = value.replaceAll(RegExp(r'\s+'), '');
    final egyptRegex = RegExp(r'^01[0-9]{9}$');
    if (!egyptRegex.hasMatch(cleaned)) {
      return 'الرجاء إدخال رقم مصري صحيح (مثال: 01134589675)';
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isLoading = true);
    try {
      final repository = ref.read(customerRepositoryProvider);
      await repository.create(
        name: _name,
        phones: _phone.isNotEmpty ? [_phone.replaceAll(RegExp(r'\s+'), '')] : [],
      );
      
      // Invalidate the provider to refresh the list
      ref.invalidate(customersProvider);
      
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تمت إضافة العميل بنجاح')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ: $e')),
        );
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

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('إضافة عميل جديد'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'اسم العميل',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? 'الرجاء إدخال اسم العميل' : null,
                onSaved: (val) => _name = val ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'رقم الهاتف',
                  hintText: '01XXXXXXXXX',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                maxLength: 11,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: _validateEgyptianPhone,
                onSaved: (val) => _phone = val ?? '',
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryContainer,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('حفظ البيانات', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
