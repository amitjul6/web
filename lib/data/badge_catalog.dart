import '../models/badge.dart';

/// All earnable badges. Earning conditions are evaluated in StreakService.
const List<Badge> kBadgeCatalog = [
  Badge(id: 'first_log', name: 'First Bite', description: 'Logged your first food', icon: '🍽️'),
  Badge(id: 'first_exercise', name: 'Get Moving', description: 'Logged your first exercise', icon: '🏃'),
  Badge(id: 'steps_goal', name: 'Goal Crusher', description: 'Hit your daily step goal', icon: '🎯'),
  Badge(id: 'steps_10k', name: '10K Club', description: 'Walked 10,000 steps in a day', icon: '👟'),
  Badge(id: 'streak_3', name: 'On a Roll', description: '3-day step streak', icon: '🔥'),
  Badge(id: 'streak_7', name: 'Week Warrior', description: '7-day step streak', icon: '🏆'),
  Badge(id: 'weight_logged', name: 'Tracker', description: 'Logged your weight', icon: '⚖️'),
];

Badge? badgeById(String id) {
  for (final b in kBadgeCatalog) {
    if (b.id == id) return b;
  }
  return null;
}
