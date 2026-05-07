import 'package:el_3mmary/core/services/supabase_service.dart';
import 'package:el_3mmary/features/customers/data/models/customer.dart';

/// Repository for customer-related database operations.
class CustomerRepository {
  CustomerRepository(this._service);

  final SupabaseService _service;

  static const _table = 'customers';
  static const _phonesTable = 'customer_phones';

  /// Fetch all customers.
  Future<List<Customer>> getAll() async {
    final data = await _service.from(_table).select().order('created_at');

    return data.map((json) => Customer.fromJson(json)).toList();
  }

  /// Fetch a single customer by ID, including their phone numbers.
  Future<Customer> getById(String id) async {
    final data =
        await _service.from(_table).select('*, customer_phones(phone_number)').eq('id', id).single();

    final phones = (data['customer_phones'] as List?)
            ?.map((e) => e['phone_number'] as String)
            .toList() ??
        [];

    return Customer.fromJson({...data, 'phones': phones});
  }

  /// Create a new customer and optionally attach phone numbers.
  Future<Customer> create({
    required String name,
    List<String> phones = const [],
  }) async {
    final row =
        await _service.from(_table).insert({'name': name}).select().single();

    final customer = Customer.fromJson(row);

    // Insert phone numbers
    if (phones.isNotEmpty) {
      await _service.from(_phonesTable).insert(
            phones
                .map((p) => {'customer_id': customer.id, 'phone_number': p})
                .toList(),
          );
    }

    return customer.copyWith(phones: phones);
  }

  /// Update an existing customer.
  Future<void> update(String id, {String? name}) async {
    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (updates.isNotEmpty) {
      await _service.from(_table).update(updates).eq('id', id);
    }
  }

  /// Delete a customer (cascades handled by FK constraints).
  Future<void> delete(String id) async {
    await _service.from(_table).delete().eq('id', id);
  }
}
