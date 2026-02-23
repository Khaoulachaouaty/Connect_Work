import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../core/utils/app_colors.dart';

class CustomerSmoothPageIndecator extends StatelessWidget {
  const CustomerSmoothPageIndecator({super.key, required this.controller});
  final PageController controller;
  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
                controller: controller, 
                count: 3,
                effect: const ExpandingDotsEffect(
                  activeDotColor: AppColor.primaryDark,
                  dotHeight: 8,
                  dotWidth: 10,
                ),
      );
  }
}