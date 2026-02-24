import 'package:connect_work/core/utils/app_assets.dart';
import 'package:flutter/material.dart';
import '../../../../core/database/cache/cache_helper.dart';
import '../../../../core/functions/navigation.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_text_styles.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

@override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    bool isOnBoardingVisited = getIt<CacheHelper>().getData(key: "isOnBoardingVisited")??false;
    if(isOnBoardingVisited==true){
      delayNavigation(context, "/login");
    }else{
      delayNavigation(context, "/onboarding");
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppColor.primaryLight, // à gauche (plus clair)
              AppColor.primaryDark,      // à droite (plus foncé)
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(Assets.imagesLogo),
              Text(
                AppStrings.appName,
                style: CustomTextStyles.appName,
              ),

              const SizedBox(height: 20),

              Text(
                AppStrings.mot,
                style: CustomTextStyles.appMot,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

  void delayNavigation(context, path) {
    Future.delayed(
      const Duration(seconds: 2), () 
      {
        customReplacementNavigate(context,path);
    });
  }