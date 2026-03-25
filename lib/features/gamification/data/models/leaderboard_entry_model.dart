import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class LeaderboardEntry {
  final String userId;
  final String userName;
  final String userInitials;
  final String weekKey;
  final String language;
  final int xpEarned;
  final int? rankPosition;

  LeaderboardEntry({
    required this.userId,
    required this.userName,
    required this.userInitials,
    required this.weekKey,
    required this.language,
    required this.xpEarned,
    this.rankPosition,
  });

  bool isCurrentUser(String currentUserId) {
    return userId == currentUserId;
  }

  List<Color> get avatarGradient {
    final bytes = utf8.encode(userInitials + userId);
    final digest = md5.convert(bytes);
    final hashCode = digest.bytes.fold<int>(0, (a, b) => a + b);

    final hue1 = (hashCode % 360).toDouble();
    final hue2 = ((hashCode + 40) % 360).toDouble();

    return [
      HSVColor.fromAHSV(1.0, hue1, 0.7, 0.8).toColor(),
      HSVColor.fromAHSV(1.0, hue2, 0.8, 0.7).toColor(),
    ];
  }

  factory LeaderboardEntry.fromMap(Map<String, dynamic> map) {
    return LeaderboardEntry(
      userId: map['user_id'] as String,
      userName: map['user_name'] as String,
      userInitials: map['user_initials'] as String,
      weekKey: map['week_key'] as String,
      language: map['language'] as String,
      xpEarned: map['xp_earned'] as int,
      rankPosition: map['rank_position'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'user_name': userName,
      'user_initials': userInitials,
      'week_key': weekKey,
      'language': language,
      'xp_earned': xpEarned,
      'rank_position': rankPosition,
    };
  }
}

class LeaderboardData {
  final List<LeaderboardEntry> topPlayers;
  final LeaderboardEntry? currentUserEntry;
  final int? currentUserRank;

  LeaderboardData({
    required this.topPlayers,
    this.currentUserEntry,
    this.currentUserRank,
  });
}
