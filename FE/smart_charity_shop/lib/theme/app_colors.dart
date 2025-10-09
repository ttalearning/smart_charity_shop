import 'package:flutter/material.dart';

/// Smart Charity Shop – Color System
/// Tông xanh lá thiện nguyện (primary), cam nổi bật cho CTA donate (secondary),
/// bảng màu trung tính dễ đọc, có sẵn light/dark, shadow & gradients.

class AppColors {
  // BRAND
  static const Color primary = Color(
    0xFF2BB673,
  ); // Green – charity / sustainability
  static const Color secondary = Color(0xFFFF7A1A); // Orange – CTA Donate
  static const Color tertiary = Color(0xFF2F80ED); // Blue – info/links

  // FEEDBACK
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  static const glassGradient = LinearGradient(
    colors: [Color(0x33FFFFFF), Color(0x22FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF42A5F5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  // NEUTRALS (Light)
  static const Color textPrimary = Color(0xFF0E141B);
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color textTertiary = Color(0xFF6B7280);

  static const Color background = Color(0xFFF8FAFC); // app bg
  static const Color surface = Color(0xFFFFFFFF); // card
  static const Color surfaceAlt = Color(0xFFF3F4F6);
  static const Color divider = Color(0xFFE5E7EB);

  // NEUTRALS (Dark)
  static const Color textPrimaryDark = Color(0xFFF3F4F6);
  static const Color textSecondaryDark = Color(0xFFD1D5DB);
  static const Color textTertiaryDark = Color(0xFFA7AFB7);

  static const Color backgroundDark = Color(0xFF0B1015);
  static const Color surfaceDark = Color(0xFF121820);
  static const Color surfaceAltDark = Color(0xFF18202A);
  static const Color dividerDark = Color(0xFF27303B);

  // STATES
  static const Color focus = Color(0xFF2563EB);
  static const Color disabled = Color(0xFF9CA3AF);

  // SHADOWS
  static const List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 16,
      spreadRadius: 0,
      offset: Offset(0, 8),
    ),
  ];

  // GRADIENTS
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF2BB673), // primary
      Color(0xFF4DD4A1),
    ],
  );

  static const LinearGradient donateGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFF8A3D), // secondary brighter
      Color(0xFFFF5C00),
    ],
  );

  static const LinearGradient blueInfoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2F80ED), Color(0xFF56A4FF)],
  );
}
