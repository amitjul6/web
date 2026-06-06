/// Streak + earned badges. A day "qualifies" when the step goal is met.
class StreakState {
  final int currentStreak;
  final int longestStreak;
  final String? lastQualifiedDayKey;
  final Set<String> earnedBadgeIds;

  const StreakState({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastQualifiedDayKey,
    this.earnedBadgeIds = const {},
  });

  StreakState copyWith({
    int? currentStreak,
    int? longestStreak,
    String? lastQualifiedDayKey,
    Set<String>? earnedBadgeIds,
  }) =>
      StreakState(
        currentStreak: currentStreak ?? this.currentStreak,
        longestStreak: longestStreak ?? this.longestStreak,
        lastQualifiedDayKey: lastQualifiedDayKey ?? this.lastQualifiedDayKey,
        earnedBadgeIds: earnedBadgeIds ?? this.earnedBadgeIds,
      );

  Map<String, dynamic> toJson() => {
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
        'lastQualifiedDayKey': lastQualifiedDayKey,
        'earnedBadgeIds': earnedBadgeIds.toList(),
      };

  factory StreakState.fromJson(Map<String, dynamic> j) => StreakState(
        currentStreak: (j['currentStreak'] as num?)?.toInt() ?? 0,
        longestStreak: (j['longestStreak'] as num?)?.toInt() ?? 0,
        lastQualifiedDayKey: j['lastQualifiedDayKey'] as String?,
        earnedBadgeIds:
            ((j['earnedBadgeIds'] as List?)?.cast<String>() ?? const [])
                .toSet(),
      );
}
