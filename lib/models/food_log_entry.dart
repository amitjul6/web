import 'food_item.dart';

/// A logged food for a given day. Calories/macros are SNAPSHOTTED at log time so
/// later edits to the library never rewrite history.
class FoodLogEntry {
  final String id;
  final String foodItemId;
  final String name;
  final String portionLabel;
  final double quantity; // multiplier of the portion
  final double caloriesPerPortion;
  final double proteinPerPortion;
  final double carbsPerPortion;
  final double fatPerPortion;
  final DateTime timestamp;

  const FoodLogEntry({
    required this.id,
    required this.foodItemId,
    required this.name,
    required this.portionLabel,
    required this.quantity,
    required this.caloriesPerPortion,
    required this.proteinPerPortion,
    required this.carbsPerPortion,
    required this.fatPerPortion,
    required this.timestamp,
  });

  double get totalCalories => caloriesPerPortion * quantity;
  double get totalProtein => proteinPerPortion * quantity;
  double get totalCarbs => carbsPerPortion * quantity;
  double get totalFat => fatPerPortion * quantity;

  factory FoodLogEntry.fromFood(FoodItem f, String id, double quantity) =>
      FoodLogEntry(
        id: id,
        foodItemId: f.id,
        name: f.name,
        portionLabel: f.portionLabel,
        quantity: quantity,
        caloriesPerPortion: f.calories,
        proteinPerPortion: f.proteinG,
        carbsPerPortion: f.carbsG,
        fatPerPortion: f.fatG,
        timestamp: DateTime.now(),
      );

  FoodLogEntry copyWith({double? quantity}) => FoodLogEntry(
        id: id,
        foodItemId: foodItemId,
        name: name,
        portionLabel: portionLabel,
        quantity: quantity ?? this.quantity,
        caloriesPerPortion: caloriesPerPortion,
        proteinPerPortion: proteinPerPortion,
        carbsPerPortion: carbsPerPortion,
        fatPerPortion: fatPerPortion,
        timestamp: timestamp,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'foodItemId': foodItemId,
        'name': name,
        'portionLabel': portionLabel,
        'quantity': quantity,
        'caloriesPerPortion': caloriesPerPortion,
        'proteinPerPortion': proteinPerPortion,
        'carbsPerPortion': carbsPerPortion,
        'fatPerPortion': fatPerPortion,
        'timestamp': timestamp.toIso8601String(),
      };

  factory FoodLogEntry.fromJson(Map<String, dynamic> j) => FoodLogEntry(
        id: j['id'] as String,
        foodItemId: j['foodItemId'] as String,
        name: j['name'] as String,
        portionLabel: j['portionLabel'] as String,
        quantity: (j['quantity'] as num).toDouble(),
        caloriesPerPortion: (j['caloriesPerPortion'] as num).toDouble(),
        proteinPerPortion: (j['proteinPerPortion'] as num).toDouble(),
        carbsPerPortion: (j['carbsPerPortion'] as num).toDouble(),
        fatPerPortion: (j['fatPerPortion'] as num).toDouble(),
        timestamp: DateTime.parse(j['timestamp'] as String),
      );
}
