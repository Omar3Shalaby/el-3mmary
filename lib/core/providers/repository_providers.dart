import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:el_3mmary/core/providers/supabase_providers.dart';
import 'package:el_3mmary/features/customers/data/repositories/customer_repository.dart';
import 'package:el_3mmary/features/inspections/data/repositories/inspection_repository.dart';
import 'package:el_3mmary/features/contracts/data/repositories/contract_repository.dart';

/// Provides a [CustomerRepository] instance.
final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  return CustomerRepository(ref.watch(supabaseServiceProvider));
});

/// Provides an [InspectionRepository] instance.
final inspectionRepositoryProvider = Provider<InspectionRepository>((ref) {
  return InspectionRepository(ref.watch(supabaseServiceProvider));
});

/// Provides a [ContractRepository] instance.
final contractRepositoryProvider = Provider<ContractRepository>((ref) {
  return ContractRepository(ref.watch(supabaseServiceProvider));
});
