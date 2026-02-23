import 'package:flutter/material.dart';

abstract class AppColor {
  // Couleur principale (Primary) - Bleu ConnectWork
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryLight = Color(0xFF3B82F6);
  
  // Couleurs de fond
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundGrey = Color(0xFFF8FAFC);
  static const Color scaffoldBackground = Color(0xFFF1F5F9);
  
  // Couleurs de texte
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textHint = Color(0xFF94A3B8);
  
  // Couleurs des cartes et surfaces
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE2E8F0);
  
  // Couleurs des champs de formulaire
  static const Color inputBackground = Color(0xFFF8FAFC);
  static const Color inputBorder = Color(0xFFE2E8F0);
  static const Color inputBorderFocused = Color(0xFF2563EB);
  
  // Couleurs d'accentuation
  static const Color accentSuccess = Color(0xFF22C55E);
  static const Color accentWarning = Color(0xFFF59E0B);
  static const Color accentError = Color(0xFFEF4444);
  
  // Couleurs pour les icônes
  static const Color iconPrimary = Color(0xFF64748B);
  static const Color iconActive = Color(0xFF2563EB);
  
  // Couleurs pour les likes/interactions
  static const Color likeActive = Color(0xFFEF4444);
  static const Color likeInactive = Color(0xFF64748B);
  
  // Ombres
  static const Color shadow = Color(0x1A000000);
  static const Color shadowLight = Color(0x0D000000);

  // Autres couleurs
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color.fromARGB(255, 34, 32, 32);
}