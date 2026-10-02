import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:el_3mmary/features/auth/presentation/login_screen.dart';
import 'package:el_3mmary/features/home/presentation/screens/home_screen.dart';
import 'package:el_3mmary/features/customers/presentation/screens/customer_list_screen.dart';
import 'package:el_3mmary/features/customers/presentation/screens/customer_details_screen.dart';
import 'package:el_3mmary/features/customers/presentation/screens/add_customer_screen.dart';
import 'package:el_3mmary/features/inspections/presentation/screens/inspections_list_screen.dart';
import 'package:el_3mmary/features/inspections/presentation/screens/add_inspection_screen.dart';
import 'package:el_3mmary/features/inspections/presentation/screens/inspection_details_screen.dart';
import 'package:el_3mmary/features/contracts/presentation/screens/contracts_list_screen.dart';
import 'package:el_3mmary/features/contracts/presentation/screens/add_contract_screen.dart';


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
      GoRoute(
        path: '/customers',
        name: 'customers',
        builder: (context, state) => const CustomerListScreen(),
        routes: [
          GoRoute(
            path: 'add',
            name: 'addCustomer',
            builder: (context, state) => const AddCustomerScreen(),
          ),
          GoRoute(
            path: ':id',
            name: 'customerDetails',
            builder: (context, state) => CustomerDetailsScreen(customerId: state.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: '/inspections',
        name: 'inspections',
        builder: (context, state) => const InspectionsListScreen(),
        routes: [
          GoRoute(
            path: 'add',
            name: 'addInspection',
            builder: (context, state) {
              final customerId = state.uri.queryParameters['customerId'];
              return AddInspectionScreen(preselectedCustomerId: customerId);
            },
          ),
          GoRoute(
            path: ':id',
            name: 'inspectionDetails',
            builder: (context, state) => InspectionDetailsScreen(inspectionId: state.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: '/contracts',
        name: 'contracts',
        builder: (context, state) => const ContractsListScreen(),
        routes: [
          GoRoute(
            path: 'add',
            name: 'addContract',
            builder: (context, state) {
              final customerId = state.uri.queryParameters['customerId'];
              return AddContractScreen(preselectedCustomerId: customerId);
            },
          ),
        ],
      ),
    ],
  );
});
