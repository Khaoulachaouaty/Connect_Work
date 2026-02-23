import 'package:flutter/material.dart';
import '../../../../core/widgets/cutsom_btn.dart';
import 'widgets/custom_nav_bar.dart';
import 'widgets/on_boarding_widget_body.dart';

class OnBoardingView extends StatelessWidget {
  const OnBoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: [
              const SizedBox(height: 40),
              CustomNavbar(),
              const SizedBox(height: 60),
              OnBoardingWidgetBody(),
              const SizedBox(height: 100),
              CustomBtn(text: "Suivant"),
            ],
          ),
        ),
      ),
    );
  }
}

