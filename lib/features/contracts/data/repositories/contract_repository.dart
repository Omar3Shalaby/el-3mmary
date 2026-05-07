import 'package:el_3mmary/core/services/supabase_service.dart';
import 'package:el_3mmary/features/contracts/data/models/contract.dart';

/// Repository for contract-related database operations.
class ContractRepository {
  ContractRepository(this._service);

  final SupabaseService _service;

  static const _table = 'contracts';

  /// Fetch all contracts.
  Future<List<Contract>> getAll() async {
    final data = await _service.from(_table).select().order('created_at');
    return data.map((json) => Contract.fromJson(json)).toList();
  }

  /// Fetch contracts for a specific customer.
  Future<List<Contract>> getByCustomerId(String customerId) async {
    final data = await _service
        .from(_table)
        .select()
        .eq('customer_id', customerId)
        .order('created_at');
    return data.map((json) => Contract.fromJson(json)).toList();
  }

  /// Create a new contract.
  Future<Contract> create({
    required String inspectionId,
    required String customerId,
    DateTime? deliveryDate,
    DateTime? pickupDate,
  }) async {
    final row = await _service
        .from(_table)
        .insert({
          'inspection_id': inspectionId,
          'customer_id': customerId,
          if (deliveryDate != null)
            'delivery_date': deliveryDate.toIso8601String().split('T').first,
          if (pickupDate != null)
            'pickup_date': pickupDate.toIso8601String().split('T').first,
        })
        .select()
        .single();
    return Contract.fromJson(row);
  }

  /// Cancel a contract.
  Future<void> cancel(String id) async {
    await _service.from(_table).update({'status': 'cancelled'}).eq('id', id);
  }

  /// Delete a contract.
  Future<void> delete(String id) async {
    await _service.from(_table).delete().eq('id', id);
  }
}
