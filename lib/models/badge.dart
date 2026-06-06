/// An achievement definition. Earning logic lives in StreakService.
class Badge {
  final String id;
  final String name;
  final String description;
  final String icon; // emoji

  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
  });
}
