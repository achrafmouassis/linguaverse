import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1A56DB);
  static const Color primaryDark = Color(0xFF0F2D5E);
  static const Color primaryLight = Color(0xFFDBEAFE);
  static const Color secondary = Color(0xFF0E7490);
  static const Color tertiary = Color(0xFF5B21B6);

  static const Color correctGreen = Color(0xFF065F46);
  static const Color wrongRed = Color(0xFF991B1B);
  static const Color streakOrange = Color(0xFFEA580C);
  static const Color xpGold = Color(0xFFF59E0B);

  static const Color background = Color(0xFFF9FAFB);
  static const Color surface = Color(0xFFFAFAFA);
  static const Color textPrimary = Color(0xFF374151);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color outline = Color(0xFFD1D5DB);

  // ── Niveaux de fond dark (Deep Space) ────────────────────────────
  // Ces constantes remplacent les Color(0xFF...) hardcodées
  // dans home_page.dart et les futurs écrans
  static const Color bgScaffold = Color(0xFF080812); // fond Scaffold (quasi-noir)
  static const Color bgLevel1 = Color(0xFF0D0D1A); // fond sections
  static const Color bgLevel2 = Color(0xFF13132A); // fond cards
  static const Color bgLevel3 = Color(0xFF1A1A35); // fond éléments interactifs
  static const Color bgLevel4 = Color(0xFF222244); // fond hover/pressed

  // ── Couleurs de récompenses et états ─────────────────────────────
  static const Color silver = Color(0xFF94A3B8);
  static const Color bronze = Color(0xFFB45309);
  static const Color glassBlue = Color(0xFFF0F0FF);
  static const Color deepSpaceBlue = Color(0xFF0F172A);
}
