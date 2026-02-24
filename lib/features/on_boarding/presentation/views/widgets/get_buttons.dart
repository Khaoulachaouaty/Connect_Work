import 'package:connect_work/features/on_boarding/presentation/views/functions/on_boarding.dart';
import 'package:flutter/material.dart';

import '../../../../../core/functions/navigation.dart';
import '../../../../../core/widgets/cutsom_btn.dart';


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
                  onBoardingVisited();
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