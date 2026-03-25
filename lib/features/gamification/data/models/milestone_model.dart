class MilestoneModel {
  final int? id;
  final String userId;
  final String milestoneType;
  final int targetValue;
  final int currentValue;
  final bool isCompleted;
  final DateTime? completedAt;
  final int xpReward;
  final DateTime createdAt;

  MilestoneModel({
    this.id,
    required this.userId,
    required this.milestoneType,
    required this.targetValue,
    this.currentValue = 0,
    this.isCompleted = false,
    this.completedAt,
    this.xpReward = 0,
    required this.createdAt,
  });

  double get progress => (currentValue / targetValue).clamp(0.0, 1.0);

  String get label {
    switch (milestoneType) {
      case 'streak_goal':
        return 'Streak de $targetValue jours';
      case 'xp_goal':
        return 'Atteindre $targetValue XP';
      case 'lessons_goal':
        return '$targetValue leçons complètes';
      case 'words_goal':
        return '$targetValue mots maîtrisés';
      case 'level_goal':
        return 'Atteindre le niveau $targetValue';
      default:
        return milestoneType;
    }
  }

  factory MilestoneModel.fromMap(Map<String, dynamic> map) {
    return MilestoneModel(
      id: map['id'] as int?,
      userId: map['user_id'] as String,
      milestoneType: map['milestone_type'] as String,
      targetValue: map['target_value'] as int,
      currentValue: map['current_value'] as int,
      isCompleted: (map['is_completed'] as int) == 1,
      completedAt:
          map['completed_at'] != null ? DateTime.parse(map['completed_at'] as String) : null,
      xpReward: map['xp_reward'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'milestone_type': milestoneType,
      'target_value': targetValue,
      'current_value': currentValue,
      'is_completed': isCompleted ? 1 : 0,
      'completed_at': completedAt?.toIso8601String(),
      'xp_reward': xpReward,
      'created_at': createdAt.toIso8601String(),
    };
  }

  MilestoneModel copyWith({
    int? currentValue,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return MilestoneModel(
      id: id,
      userId: userId,
      milestoneType: milestoneType,
      targetValue: targetValue,
      currentValue: currentValue ?? this.currentValue,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      xpReward: xpReward,
      createdAt: createdAt,
    );
  }
}
