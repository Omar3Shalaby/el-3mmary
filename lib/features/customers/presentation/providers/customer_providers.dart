import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:el_3mmary/core/providers/repository_providers.dart';
import 'package:el_3mmary/features/customers/data/models/customer.dart';

final customersProvider = FutureProvider<List<Customer>>((ref) async {
  return ref.watch(customerRepositoryProvider).getAll();
});

final customerDetailsProvider = FutureProvider.family<Customer, String>((ref, id) async {
  return ref.watch(customerRepositoryProvider).getById(id);
});

/// A search query state for filtering customers.
final customerSearchQueryProvider = StateProvider<String>((ref) => '');

/// Provides a filtered list of customers based on the search query.
final filteredCustomersProvider = Provider<AsyncValue<List<Customer>>>((ref) {
  final query = ref.watch(customerSearchQueryProvider).trim();
  final customersAsync = ref.watch(customersProvider);

  return customersAsync.whenData((customers) {
    if (query.isEmpty) return customers;
    return customers
        .where((c) =>
            c.name.contains(query) ||
            c.phones.any((p) => p.contains(query)))
        .toList();
  });
});

/// A map provider to quickly look up customer names by ID.
/// This avoids making individual DB calls for every inspection/contract card.
final customerNameMapProvider = Provider<AsyncValue<Map<String, String>>>((ref) {
  final customersAsync = ref.watch(customersProvider);
  return customersAsync.whenData((customers) {
    return {for (final c in customers) c.id: c.name};
  });
});
