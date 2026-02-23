import 'package:flutter/material.dart';

class AppColors {
  // Primary
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFF818CF8);

  // Backgrounds
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textHint = Color(0xFF94A3B8);

  // Status
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // Social
  static const Color google = Color(0xFFEA4335);
  static const Color apple = Color(0xFF000000);
  static const Color facebook = Color(0xFF1877F2);

  // Neutral
  static const Color grey100 = Color(0xFFF1F5F9);
  static const Color grey200 = Color(0xFFE2E8F0);
  static const Color grey300 = Color(0xFFCBD5E1);
  static const Color white = Colors.white;
  static const Color transparent = Colors.transparent;
}

class AppShadows {
  static BoxShadow get small => BoxShadow(
        color: const Color(0xFF6366F1).withOpacity(0.08),
        blurRadius: 8,
        offset: const Offset(0, 2),
      );

  static BoxShadow get medium => BoxShadow(
        color: const Color(0xFF6366F1).withOpacity(0.12),
        blurRadius: 16,
        offset: const Offset(0, 4),
      );

  static BoxShadow get large => BoxShadow(
        color: const Color(0xFF6366F1).withOpacity(0.15),
        blurRadius: 32,
        offset: const Offset(0, 8),
      );

  static BoxShadow get glow => BoxShadow(
        color: AppColors.primary.withOpacity(0.3),
        blurRadius: 20,
        spreadRadius: 2,
      );
}