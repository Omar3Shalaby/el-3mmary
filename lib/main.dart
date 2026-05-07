import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:el_3mmary/core/router/app_router.dart';
import 'package:el_3mmary/core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ullktwxxxrknyqrmmyfn.supabase.co',
    anonKey: 'sb_publishable_5oMdriIa3G_Ic_AQPa6e4Q_8uO90Hz4',
  );

  runApp(const ProviderScope(child: MyApp()));
}

/// Global accessor for the Supabase client.
final supabase = Supabase.instance.client;

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'العماري',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}