import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:el_3mmary/core/providers/repository_providers.dart';
import 'package:el_3mmary/features/contracts/data/models/contract.dart';

final contractsProvider = FutureProvider<List<Contract>>((ref) async {
  return ref.watch(contractRepositoryProvider).getAll();
});

final customerContractsProvider = FutureProvider.family<List<Contract>, String>((ref, customerId) async {
  return ref.watch(contractRepositoryProvider).getByCustomerId(customerId);
});
