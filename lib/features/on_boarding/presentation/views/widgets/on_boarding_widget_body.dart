import 'package:connect_work/features/on_boarding/presentation/views/widgets/custom_smooth_page_indicator.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_text_styles.dart';

class OnBoardingWidgetBody extends StatelessWidget {
  OnBoardingWidgetBody({super.key});

  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView.builder(
        controller: _controller,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Image.asset(Assets.imagesOnboarding1),
              const SizedBox(height: 24),
              CustomerSmoothPageIndecator(controller: _controller),
              const SizedBox(height: 24),
              Text(
                "Connectez-vous avec votre équipe",
                style: CustomTextStyles.onboarding, 
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
               Text(
                "Restez informé et partagez des informations importantes avec vos collègues, où que vous soyez",
                style: CustomTextStyles.onboarding2,
                textAlign: TextAlign.center,
              ),
              
            ],
          );
        }
      ),
    );
  }
}