import 'package:connect_work/core/database/cache/cache_helper.dart';
import 'package:connect_work/core/routes/app_router.dart';
import 'package:connect_work/core/services/service_locator.dart';
import 'package:flutter/material.dart';

import 'core/utils/app_colors.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServerLocator();
  await getIt<CacheHelper>().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        scaffoldBackgroundColor: AppColor.background),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}

