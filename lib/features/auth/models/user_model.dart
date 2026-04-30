import 'package:cloud_firestore/cloud_firestore.dart';

/// Représente un utilisateur LinguaVerse
class UserModel {
  final String id; // UID Firebase
  final String email;
  final String? displayName;
  final String? profileImageUrl;

  // Apprentissage
  final String languageLevel; // A1, A2, B1, B2, C1, C2
  final String learningGoal; // TRAVEL, WORK, CULTURE, HOBBY
  final String dailyLearningMinutes; // 5, 15, 30, 60
  final String preferredTheme; // ARABIC, ENGLISH, FRENCH, SPANISH

  // Gamification
  final int xpTotal;
  final int streakDays;
  final int lessonsCompleted;
  final DateTime? lastActivityDate;

  // Métadonnées
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isOnboarded;

  const UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.profileImageUrl,
    required this.languageLevel,
    required this.learningGoal,
    required this.dailyLearningMinutes,
    required this.preferredTheme,
    this.xpTotal = 0,
    this.streakDays = 0,
    this.lessonsCompleted = 0,
    this.lastActivityDate,
    required this.createdAt,
    required this.updatedAt,
    this.isOnboarded = false,
  });

  /// Crée un UserModel à partir d'un DocumentSnapshot Firebase
  factory UserModel.fromFirebase(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] as String,
      displayName: data['displayName'] as String?,
      profileImageUrl: data['profileImageUrl'] as String?,
      languageLevel: data['languageLevel'] as String? ?? 'A1',
      learningGoal: data['learningGoal'] as String? ?? 'CULTURE',
      dailyLearningMinutes: data['dailyLearningMinutes'] as String? ?? '15',
      preferredTheme: data['preferredTheme'] as String? ?? 'ARABIC',
      xpTotal: data['xpTotal'] as int? ?? 0,
      streakDays: data['streakDays'] as int? ?? 0,
      lessonsCompleted: data['lessonsCompleted'] as int? ?? 0,
      lastActivityDate: data['lastActivityDate'] != null
          ? (data['lastActivityDate'] as Timestamp).toDate()
          : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      isOnboarded: data['isOnboarded'] as bool? ?? false,
    );
  }

  /// Crée un UserModel à partir d'un Map (pour sqflite)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      displayName: map['displayName'] as String?,
      profileImageUrl: map['profileImageUrl'] as String?,
      languageLevel: map['languageLevel'] as String? ?? 'A1',
      learningGoal: map['learningGoal'] as String? ?? 'CULTURE',
      dailyLearningMinutes: map['dailyLearningMinutes'] as String? ?? '15',
      preferredTheme: map['preferredTheme'] as String? ?? 'ARABIC',
      xpTotal: map['xpTotal'] as int? ?? 0,
      streakDays: map['streakDays'] as int? ?? 0,
      lessonsCompleted: map['lessonsCompleted'] as int? ?? 0,
      lastActivityDate: map['lastActivityDate'] != null
          ? DateTime.parse(map['lastActivityDate'] as String)
          : null,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      isOnboarded: (map['isOnboarded'] as int?) == 1,
    );
  }

  /// Convertit le UserModel en Map pour sqflite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'profileImageUrl': profileImageUrl,
      'languageLevel': languageLevel,
      'learningGoal': learningGoal,
      'dailyLearningMinutes': dailyLearningMinutes,
      'preferredTheme': preferredTheme,
      'xpTotal': xpTotal,
      'streakDays': streakDays,
      'lessonsCompleted': lessonsCompleted,
      'lastActivityDate': lastActivityDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isOnboarded': isOnboarded ? 1 : 0,
    };
  }

  /// Convertit le UserModel en objet Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'profileImageUrl': profileImageUrl,
      'languageLevel': languageLevel,
      'learningGoal': learningGoal,
      'dailyLearningMinutes': dailyLearningMinutes,
      'preferredTheme': preferredTheme,
      'xpTotal': xpTotal,
      'streakDays': streakDays,
      'lessonsCompleted': lessonsCompleted,
      'lastActivityDate': lastActivityDate != null
          ? Timestamp.fromDate(lastActivityDate!)
          : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isOnboarded': isOnboarded,
    };
  }

  /// Crée une copie du UserModel avec certains champs remplacés
  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? profileImageUrl,
    String? languageLevel,
    String? learningGoal,
    String? dailyLearningMinutes,
    String? preferredTheme,
    int? xpTotal,
    int? streakDays,
    int? lessonsCompleted,
    DateTime? lastActivityDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isOnboarded,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      languageLevel: languageLevel ?? this.languageLevel,
      learningGoal: learningGoal ?? this.learningGoal,
      dailyLearningMinutes: dailyLearningMinutes ?? this.dailyLearningMinutes,
      preferredTheme: preferredTheme ?? this.preferredTheme,
      xpTotal: xpTotal ?? this.xpTotal,
      streakDays: streakDays ?? this.streakDays,
      lessonsCompleted: lessonsCompleted ?? this.lessonsCompleted,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isOnboarded: isOnboarded ?? this.isOnboarded,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, level: $languageLevel, xp: $xpTotal)';
  }
}
