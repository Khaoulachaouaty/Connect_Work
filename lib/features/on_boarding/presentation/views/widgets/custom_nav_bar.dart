import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_strings.dart';

class CustomNavbar extends StatelessWidget {
  const CustomNavbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Text(
          AppStrings.skip,
          style: TextStyle(
            color: AppColor.primaryDark,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

