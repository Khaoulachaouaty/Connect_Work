import 'package:connect_work/core/routes/app_router.dart';
import 'package:flutter/material.dart';

import 'core/utils/app_colors.dart';



void main() {
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

