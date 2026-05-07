import 'package:supabase_flutter/supabase_flutter.dart';

/// Thin wrapper around [SupabaseClient] for easy injection via Riverpod.
///
/// All database / auth / storage calls should go through this service
/// so that we have a single point of access.
class SupabaseService {
  SupabaseService._();

  static final SupabaseService _instance = SupabaseService._();
  static SupabaseService get instance => _instance;

  SupabaseClient get client => Supabase.instance.client;

  // ── Auth helpers ────────────────────────────────────────────────────
  GoTrueClient get auth => client.auth;
  User? get currentUser => auth.currentUser;
  String? get userId => currentUser?.id;
  bool get isAuthenticated => currentUser != null;

  /// Sign in with email & password.
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) {
    return auth.signInWithPassword(email: email, password: password);
  }

  /// Register a new user with email & password.
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) {
    return auth.signUp(email: email, password: password);
  }

  /// Sign out the current user.
  Future<void> signOut() => auth.signOut();

  // ── Database helpers ────────────────────────────────────────────────
  SupabaseQueryBuilder from(String table) => client.from(table);
}
