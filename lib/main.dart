// lib/main.dart
import 'package:connect_work/core/database/cache/cache_helper.dart';
import 'package:connect_work/core/routes/app_router.dart';
import 'package:connect_work/core/services/service_locator.dart';
import 'package:connect_work/features/admin/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:connect_work/features/admin/employees/presentation/cubit/employee_cubit.dart';
import 'package:connect_work/features/admin/groups/presentation/cubit/group_cubit.dart';
import 'package:connect_work/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/utils/app_colors.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  setupServerLocator();
  await getIt<CacheHelper>().init();

  runApp(
    MultiBlocProvider(
      providers: [
        // Auth
        BlocProvider<AuthCubit>(create: (_) => getIt<AuthCubit>()),
        
        // Admin - Dashboard
        BlocProvider<DashboardCubit>(create: (_) => getIt<DashboardCubit>()),
        
        // Admin - Employees
        BlocProvider<EmployeeCubit>(create: (_) => getIt<EmployeeCubit>()),
        
        // Admin - Groups
        BlocProvider<GroupCubit>(create: (_) => getIt<GroupCubit>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColor.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: MaterialApp.router(
        title: 'Connect Work',
        theme: ThemeData(
          scaffoldBackgroundColor: AppColor.background,
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
            ),
          ),
          primarySwatch: Colors.blue,
          fontFamily: 'Poppins',
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}