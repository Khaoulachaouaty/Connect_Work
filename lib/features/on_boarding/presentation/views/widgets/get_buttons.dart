import 'package:flutter/material.dart';

import '../../../../../core/functions/navigation.dart';
import '../../../../../core/widgets/cutsom_btn.dart';
import '../on_boarding_view.dart';
import 'custom_nav_bar.dart';
import 'on_boarding_widget_body.dart';

class _OnBoardingViewState extends State<OnBoardingView> {
  final PageController _controller = PageController(initialPage: 0);
  int currentIndex =0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: [
              const SizedBox(height: 40),
              CustomNavbar(onTap: () { 
                customNavigate(context, "/login");
               },),
              const SizedBox(height: 60),
              OnBoardingWidgetBody(
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                controller: _controller),
              const SizedBox(height: 100),
              GetButtons(
                currentIndex: currentIndex,
                controller: _controller,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GetButtons extends StatelessWidget {
  const GetButtons({
    super.key,
    required this.currentIndex,
    required this.controller,
  });

  final int currentIndex;
  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        currentIndex == 2
            ? CustomBtn(
                text: "Connectez-vous",
                onPressed: () {
                  customNavigate(context, "/login");
                },
              )
            : CustomBtn(
                text: "Suivant",
                onPressed: () {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                  );
                },
              ),
      ],
    );
  }
}