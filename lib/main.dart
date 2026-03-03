import 'package:connect_work/core/database/cache/cache_helper.dart';
import 'package:connect_work/core/routes/app_router.dart';
import 'package:connect_work/core/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/utils/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Imposer la status bar blanche globalement
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,           // Fond blanc
      statusBarIconBrightness: Brightness.dark, // Icônes noires
      statusBarBrightness: Brightness.light,    // Pour iOS
      systemNavigationBarColor: Colors.white,   // Barre de navigation Android
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  setupServerLocator();
  await getIt<CacheHelper>().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Maintient le style dans toute l'app
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColor.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: MaterialApp.router(
        theme: ThemeData(
          scaffoldBackgroundColor: AppColor.background,
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}