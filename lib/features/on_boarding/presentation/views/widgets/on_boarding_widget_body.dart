import 'package:connect_work/features/on_boarding/presentation/views/widgets/custom_smooth_page_indicator.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utils/app_text_styles.dart';
import 'package:connect_work/features/on_boarding/data/models/on_boarding_model.dart';

class OnBoardingWidgetBody extends StatelessWidget {
  OnBoardingWidgetBody({super.key});

  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: PageView.builder(
        controller: _controller,
        itemCount: onBoardingData.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                height: 290,
                width: 343,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(onBoardingData[index].imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              CustomerSmoothPageIndecator(controller: _controller),
              const SizedBox(height: 24),
              Text(
                onBoardingData[index].title,
                style: CustomTextStyles.onboarding, 
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 24),
               Text(
                onBoardingData[index].subTitle,
                style: CustomTextStyles.onboarding2,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              
            ],
          );
        }
      ),
    );
  }
}