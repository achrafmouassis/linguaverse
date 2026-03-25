import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';

class BadgeModel {
  final String badgeKey;
  final String name;
  final String description;
  final String category;
  final String iconEmoji;
  final String colorHex;
  final String rarity;
  final int sortOrder;
  final DateTime? earnedAt;
  final int? xpRewarded;

  BadgeModel({
    required this.badgeKey,
    required this.name,
    required this.description,
    required this.category,
    required this.iconEmoji,
    required this.colorHex,
    required this.rarity,
    required this.sortOrder,
    this.earnedAt,
    this.xpRewarded,
  });

  bool get isEarned => earnedAt != null;

  Color get color => Color(int.parse('0xFF${colorHex.replaceAll("#", "")}'));

  Color get rarityGlowColor {
    switch (rarity) {
      case 'rare':
        return AppColors.secondary;
      case 'epic':
        return AppColors.tertiary;
      case 'legendary':
        return AppColors.xpGold;
      default:
        return AppColors.textSecondary;
    }
  }

  String get rarityLabel {
    switch (rarity) {
      case 'rare':
        return 'Rare';
      case 'epic':
        return 'Épique';
      case 'legendary':
        return 'Légendaire';
      default:
        return 'Commun';
    }
  }

  factory BadgeModel.fromMap(Map<String, dynamic> map, {Map<String, dynamic>? userBadgeMap}) {
    return BadgeModel(
      badgeKey: map['badge_key'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      iconEmoji: map['icon_emoji'] as String,
      colorHex: map['color_hex'] as String,
      rarity: map['rarity'] as String,
      sortOrder: map['sort_order'] as int,
      earnedAt: userBadgeMap != null ? DateTime.parse(userBadgeMap['earned_at'] as String) : null,
      xpRewarded: userBadgeMap != null ? userBadgeMap['xp_rewarded'] as int? : null,
    );
  }

  BadgeModel copyWith({
    DateTime? earnedAt,
    int? xpRewarded,
  }) {
    return BadgeModel(
      badgeKey: badgeKey,
      name: name,
      description: description,
      category: category,
      iconEmoji: iconEmoji,
      colorHex: colorHex,
      rarity: rarity,
      sortOrder: sortOrder,
      earnedAt: earnedAt ?? this.earnedAt,
      xpRewarded: xpRewarded ?? this.xpRewarded,
    );
  }
}
