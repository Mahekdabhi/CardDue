import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Theme Colors (Dark)
  static const Color darkBg = Color(0xFF070A0F);
  static const Color darkCard = Color(0xFF0F141C);
  static const Color darkBorder = Color(0xFF1B2330);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  // Primary Theme Colors (Light)
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);

  // Semantic Status Colors
  static const Color accent = Color(0xFF6366F1); // Indigo
  static const Color paid = Color(0xFF10B981); // Emerald Green
  static const Color overdue = Color(0xFFEF4444); // Rose Red
  static const Color warning = Color(0xFFF59E0B); // Amber Yellow
  static const Color info = Color(0xFF3B82F6); // Blue

  // Premium Credit Card Gradient Palettes
  static const List<Color> carbonGradient = [
    Color(0xFF1E293B),
    Color(0xFF0F172A),
    Color(0xFF020617),
  ];

  static const List<Color> sapphireGradient = [
    Color(0xFF2563EB),
    Color(0xFF1D4ED8),
    Color(0xFF1E3A8A),
  ];

  static const List<Color> emeraldGradient = [
    Color(0xFF059669),
    Color(0xFF047857),
    Color(0xFF064E3B),
  ];

  static const List<Color> amethystGradient = [
    Color(0xFF7C3AED),
    Color(0xFF6D28D9),
    Color(0xFF4C1D95),
  ];

  static const List<Color> crimsonGradient = [
    Color(0xFFDC2626),
    Color(0xFFB91C1C),
    Color(0xFF7F1D1D),
  ];

  static const List<Color> sunsetGradient = [
    Color(0xFFF97316),
    Color(0xFFEA580C),
    Color(0xFF9A3412),
  ];

  static const List<Color> roseGoldGradient = [
    Color(0xFFFDA4AF),
    Color(0xFFF43F5E),
    Color(0xFFBE123C),
  ];

  // Helper to fetch card gradient by color string
  static List<Color> getCardGradient(String? colorName) {
    switch (colorName?.toLowerCase()) {
      case 'carbon':
        return carbonGradient;
      case 'sapphire':
        return sapphireGradient;
      case 'emerald':
        return emeraldGradient;
      case 'amethyst':
        return amethystGradient;
      case 'crimson':
        return crimsonGradient;
      case 'sunset':
        return sunsetGradient;
      case 'rosegoold':
      case 'rosegold':
        return roseGoldGradient;
      default:
        return sapphireGradient;
    }
  }
}
