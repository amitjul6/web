/// A static library food. Calories/macros are per one [portionLabel].
class FoodItem {
  final String id;
  final String name;
  final String category;
  final String portionLabel;
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;

  const FoodItem({
    required this.id,
    required this.name,
    required this.category,
    required this.portionLabel,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });
}
