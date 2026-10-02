import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:el_3mmary/core/providers/repository_providers.dart';
import 'package:el_3mmary/features/inspections/data/models/inspection.dart';

final inspectionsProvider = FutureProvider<List<Inspection>>((ref) async {
  return ref.watch(inspectionRepositoryProvider).getAll();
});

final customerInspectionsProvider = FutureProvider.family<List<Inspection>, String>((ref, customerId) async {
  return ref.watch(inspectionRepositoryProvider).getByCustomerId(customerId);
});
