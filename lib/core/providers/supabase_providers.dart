import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:el_3mmary/core/services/supabase_service.dart';

/// Provides the [SupabaseService] singleton.
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService.instance;
});

/// Provides the raw [SupabaseClient] if needed directly.
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return ref.watch(supabaseServiceProvider).client;
});

/// Stream of auth state changes — useful for reactive UI.
final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(supabaseServiceProvider).auth.onAuthStateChange;
});
