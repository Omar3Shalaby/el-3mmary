import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:el_3mmary/features/auth/presentation/login_screen.dart';
import 'package:el_3mmary/features/home/presentation/home_screen.dart';

/// Provides the GoRouter instance to the entire app via Riverpod.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final session = Supabase.instance.client.auth.currentSession;
      final isOnLogin = state.matchedLocation == '/login';

      // Not authenticated → force login.
      if (session == null && !isOnLogin) return '/login';

      // Authenticated but still on login → go home.
      if (session != null && isOnLogin) return '/';

      return null; // no redirect
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
});
