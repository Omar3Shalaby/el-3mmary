import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // 1. استيراد المكتبة
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

final supabase = Supabase.instance.client;

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'العماري',
      debugShowCheckedModeBanner: false,
      
      // --- إعدادات اللغة العربية (RTL) ---
      locale: const Locale('ar'), // تحديد لغة التطبيق كعربية
      supportedLocales: const [
        Locale('ar'), // دعم اللغة العربية فقط
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // ---------------------------------

     
      // إذا كنت تريد إجبار التطبيق على الوضع الفاتح دائماً كما في التصميم:
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light, 
      routerConfig: router,
    );
  }
}