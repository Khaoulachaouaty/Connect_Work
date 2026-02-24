import '../../../../../core/database/cache/cache_helper.dart';
import '../../../../../core/services/service_locator.dart';

void onBoardingVisited(){
  getIt<CacheHelper>().saveData(key: "isOnBoardingVisited", value: true);

}