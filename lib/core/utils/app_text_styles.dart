import './app_colors.dart';
import 'package:flutter/material.dart';

abstract class CustomTextStyles {
  static final appName = TextStyle(
    fontSize: 40, 
    fontWeight: FontWeight.bold,
    color: AppColor.white);
  static final appMot = TextStyle(
    fontSize: 15, 
    fontWeight: FontWeight.bold,
    color: AppColor.white);
  static final onboarding = TextStyle(
    fontSize: 25, 
    fontWeight: FontWeight.w500,
    color: AppColor.black);
  static final onboarding2 = TextStyle(
    fontSize: 15, 
    fontWeight: FontWeight.w400,
    color: AppColor.black);
}