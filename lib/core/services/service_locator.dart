import 'package:connect_work/core/database/cache/cache_helper.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;
void setupServerLocator(){
  getIt.registerSingleton(CacheHelper());
}