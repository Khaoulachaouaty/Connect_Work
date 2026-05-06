// lib/core/services/service_locator.dart
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Admin services
import '../../features/admin/dashboard/data/services/dashboard_service.dart';
import '../../features/admin/employees/data/services/employee_service.dart';
import '../../features/admin/groups/data/services/group_service.dart' as admin_group;
import '../../features/groups/data/services/group_service.dart';
import '../../features/posts/data/services/post_service.dart';
import '../../features/messages/data/services/chat_service.dart';
import '../services/notification_service.dart';

// Admin cubits
import '../../features/admin/dashboard/presentation/cubit/dashboard_cubit.dart';
import '../../features/admin/employees/presentation/cubit/employee_cubit.dart';
import '../../features/admin/groups/presentation/cubit/group_cubit.dart';

// Auth
import '../../features/auth/data/services/auth_service.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

// Core
import '../database/cache/cache_helper.dart';

final getIt = GetIt.instance;

void setupServerLocator() {
  // Core
  getIt.registerSingleton<CacheHelper>(CacheHelper());
  
  // Auth
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthService>()));
  
  // Admin - Dashboard
  getIt.registerSingleton<DashboardService>(DashboardService());
  getIt.registerFactory<DashboardCubit>(() => DashboardCubit(getIt<DashboardService>()));
  
  // Admin - Employees
  getIt.registerSingleton<EmployeeService>(EmployeeService());
  getIt.registerFactory<EmployeeCubit>(() => EmployeeCubit(getIt<EmployeeService>()));
  
  // Admin - Groups
  getIt.registerSingleton<admin_group.GroupService>(admin_group.GroupService());
  getIt.registerFactory<GroupCubit>(() => GroupCubit(getIt<admin_group.GroupService>()));

  // Employee - Groups
  getIt.registerSingleton<GroupService>(GroupService());

  // Posts
  getIt.registerSingleton<PostService>(PostService());

  // Notifications
  getIt.registerSingleton<NotificationService>(NotificationService());

  // Messages
  getIt.registerSingleton<ChatService>(ChatService());
}