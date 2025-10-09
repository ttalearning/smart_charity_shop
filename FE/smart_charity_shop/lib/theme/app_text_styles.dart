import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Smart Charity Shop – Typography Scale
/// Dễ đọc, tương phản tốt; có số “tabular” cho số liệu gây quỹ.

class AppTextStyles {
  // DISPLAY & HEADINGS
  static const TextStyle display = TextStyle(
    fontSize: 40,
    height: 1.16,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle h1 = TextStyle(
    fontSize: 28,
    height: 1.18,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 22,
    height: 1.22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.1,
    color: AppColors.textPrimary,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 18,
    height: 1.25,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // BODY
  static const TextStyle body = TextStyle(
    fontSize: 16,
    height: 1.42,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodyBold = TextStyle(
    fontSize: 16,
    height: 1.42,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 13,
    height: 1.38,
    fontWeight: FontWeight.w500,
    color: AppColors.textTertiary,
  );

  static const TextStyle tiny = TextStyle(
    fontSize: 11,
    height: 1.3,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    color: AppColors.textTertiary,
  );

  // INTERACTIVE
  static const TextStyle button = TextStyle(
    fontSize: 15,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
    color: Colors.white,
  );

  static const TextStyle chip = TextStyle(
    fontSize: 13,
    height: 1.1,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
    color: AppColors.textSecondary,
  );

  // NUMBERS – dùng cho số tiền / % tiến độ (tabular)
  static TextStyle get number => const TextStyle(
    fontFamilyFallback: ['Roboto', 'Arial', 'sans-serif'],
    fontFeatures: [FontFeature.tabularFigures()],
    fontSize: 18,
    height: 1.2,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // DARK MODE helpers
  static TextStyle dark(TextStyle t) =>
      t.copyWith(color: _darkColorFor(t.color));
  static Color _darkColorFor(Color? c) {
    if (c == AppColors.textPrimary) return AppColors.textPrimaryDark;
    if (c == AppColors.textSecondary) return AppColors.textSecondaryDark;
    if (c == AppColors.textTertiary) return AppColors.textTertiaryDark;
    return c ?? AppColors.textPrimaryDark;
  }
}
