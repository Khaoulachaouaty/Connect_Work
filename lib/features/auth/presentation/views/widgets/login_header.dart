import 'package:flutter/material.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/app_text_styles.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(Assets.imagesLogoBlue),
        const SizedBox(height: 20),
        Text(
          AppStrings.appName,
          style: CustomTextStyles.appName.copyWith(
            color: AppColor.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          AppStrings.connect,
          style: CustomTextStyles.appMot.copyWith(
            color: AppColor.textSecondary,
          ),
        ),
      ],
    );
  }
}