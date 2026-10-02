import 'package:el_3mmary/core/services/supabase_service.dart';
import 'package:el_3mmary/features/inspections/data/models/inspection.dart';
import 'package:el_3mmary/features/inspections/data/models/inspection_item.dart';

/// Repository for inspection-related database operations.
class InspectionRepository {
  InspectionRepository(this._service);

  final SupabaseService _service;

  static const _table = 'inspections';
  static const _itemsTable = 'inspection_items';

  /// Fetch all inspections.
  Future<List<Inspection>> getAll() async {
    final data = await _service.from(_table).select().order('created_at');
    return data.map((json) => Inspection.fromJson(json)).toList();
  }

  /// Fetch inspections for a specific customer.
  Future<List<Inspection>> getByCustomerId(String customerId) async {
    final data = await _service
        .from(_table)
        .select()
        .eq('customer_id', customerId)
        .order('created_at');
    return data.map((json) => Inspection.fromJson(json)).toList();
  }

  /// Create a new inspection.
  Future<Inspection> create({
    required String customerId,
    required String address,
    String? notes,
    DateTime? scheduledFrom,
    DateTime? scheduledTo,
  }) async {
    final row = await _service
        .from(_table)
        .insert({
          'customer_id': customerId,
          'address': address,
          if (notes != null) 'notes': notes,
          if (scheduledFrom != null)
            'scheduled_from': scheduledFrom.toIso8601String(),
          if (scheduledTo != null)
            'scheduled_to': scheduledTo.toIso8601String(),
        })
        .select()
        .single();
    return Inspection.fromJson(row);
  }

  /// Update inspection status.
  Future<void> updateStatus(String id, String status) async {
    await _service.from(_table).update({'status': status}).eq('id', id);
  }

  /// Delete an inspection.
  Future<void> delete(String id) async {
    await _service.from(_table).delete().eq('id', id);
  }

  // ── Inspection Items ────────────────────────────────────────────────

  /// Fetch items for an inspection.
  Future<List<InspectionItem>> getItems(String inspectionId) async {
    final data = await _service
        .from(_itemsTable)
        .select()
        .eq('inspection_id', inspectionId);
    return data.map((json) => InspectionItem.fromJson(json)).toList();
  }

  /// Add an item to an inspection.
  Future<InspectionItem> addItem({
    required String inspectionId,
    required String itemName,
    required double price,
    int quantity = 1,
    String? description,
  }) async {
    final row = await _service
        .from(_itemsTable)
        .insert({
          'inspection_id': inspectionId,
          'item_name': itemName,
          'price': price,
          'quantity': quantity,
          if (description != null) 'description': description,
        })
        .select()
        .single();
    return InspectionItem.fromJson(row);
  }

  /// Remove an item from an inspection.
  Future<void> removeItem(String itemId) async {
    await _service.from(_itemsTable).delete().eq('id', itemId);
  }
}
