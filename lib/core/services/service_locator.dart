import 'package:connect_work/core/database/cache/cache_helper.dart';
import 'package:connect_work/features/auth/data/services/auth_service.dart';
import 'package:connect_work/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:connect_work/features/posts/data/services/post_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;
void setupServerLocator(){
  getIt.registerSingleton(CacheHelper());
  getIt.registerSingleton(AuthService());
  getIt.registerFactory(() => AuthCubit(getIt<AuthService>()));
  getIt.registerSingleton(PostService());
}