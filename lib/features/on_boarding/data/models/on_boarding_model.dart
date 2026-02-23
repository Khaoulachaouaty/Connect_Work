import '../../../../core/utils/app_assets.dart';

class OnboardingModel {
  final String imagePath;
  final String title;
  final String subTitle;

  OnboardingModel({
    required this.imagePath, 
    required this.title, 
    required this.subTitle});
}

List<OnboardingModel> onBoardingData = [
  OnboardingModel(
    imagePath: Assets.imagesOnboarding1,
    title: "Connectez-vous avec votre équipe",
    subTitle: "Restez informé et partagez des informations importantes avec vos collègues, où que vous soyez",
  ),

  OnboardingModel(
    imagePath: Assets.imagesOnboarding4,
    title: "Communiquez facilement",
    subTitle: "Envoyez des messages privés ou discutez dans des groupes pour rester en contact avec votre équipe",
  ),

  OnboardingModel(
    imagePath: Assets.imagesOnboarding2,
    title: "Collaborez et partagez",
    subTitle: "Rejoignez des groupes, partagez des fichiers et contribuez aux projets de votre entreprise facilement",
  ),
];

