import '../models/food_item.dart';

/// Built-in Indian food library. Calories/macros are typical estimates per the
/// listed portion. Macros are grams of protein/carbs/fat.
const List<FoodItem> kFoodLibrary = [
  // ---------- Breads ----------
  FoodItem(id: 'roti', name: 'Roti / Chapati', category: 'Breads', portionLabel: '1 medium', calories: 104, proteinG: 3, carbsG: 18, fatG: 3),
  FoodItem(id: 'paratha_plain', name: 'Plain Paratha', category: 'Breads', portionLabel: '1 piece', calories: 126, proteinG: 3, carbsG: 18, fatG: 5),
  FoodItem(id: 'aloo_paratha', name: 'Aloo Paratha', category: 'Breads', portionLabel: '1 piece', calories: 210, proteinG: 5, carbsG: 30, fatG: 8),
  FoodItem(id: 'naan', name: 'Naan', category: 'Breads', portionLabel: '1 piece', calories: 262, proteinG: 9, carbsG: 45, fatG: 5),
  FoodItem(id: 'butter_naan', name: 'Butter Naan', category: 'Breads', portionLabel: '1 piece', calories: 320, proteinG: 9, carbsG: 45, fatG: 12),
  FoodItem(id: 'tandoori_roti', name: 'Tandoori Roti', category: 'Breads', portionLabel: '1 piece', calories: 110, proteinG: 3, carbsG: 22, fatG: 1),
  FoodItem(id: 'bhatura', name: 'Bhatura', category: 'Breads', portionLabel: '1 piece', calories: 230, proteinG: 5, carbsG: 33, fatG: 9),
  FoodItem(id: 'puri', name: 'Puri', category: 'Breads', portionLabel: '1 piece', calories: 85, proteinG: 1.5, carbsG: 9, fatG: 5),

  // ---------- Rice ----------
  FoodItem(id: 'steamed_rice', name: 'Steamed Rice', category: 'Rice', portionLabel: '1 cup', calories: 205, proteinG: 4, carbsG: 45, fatG: 0.4),
  FoodItem(id: 'jeera_rice', name: 'Jeera Rice', category: 'Rice', portionLabel: '1 cup', calories: 245, proteinG: 4, carbsG: 45, fatG: 6),
  FoodItem(id: 'veg_biryani', name: 'Veg Biryani', category: 'Rice', portionLabel: '1 cup', calories: 240, proteinG: 6, carbsG: 38, fatG: 7),
  FoodItem(id: 'chicken_biryani', name: 'Chicken Biryani', category: 'Rice', portionLabel: '1 cup', calories: 290, proteinG: 14, carbsG: 35, fatG: 10),
  FoodItem(id: 'lemon_rice', name: 'Lemon Rice', category: 'Rice', portionLabel: '1 cup', calories: 220, proteinG: 4, carbsG: 38, fatG: 6),
  FoodItem(id: 'curd_rice', name: 'Curd Rice', category: 'Rice', portionLabel: '1 cup', calories: 200, proteinG: 6, carbsG: 32, fatG: 5),
  FoodItem(id: 'veg_pulao', name: 'Pulao (Veg)', category: 'Rice', portionLabel: '1 cup', calories: 230, proteinG: 5, carbsG: 40, fatG: 6),

  // ---------- Dals & Curries ----------
  FoodItem(id: 'dal_tadka', name: 'Dal Tadka', category: 'Dals & Curries', portionLabel: '1 cup', calories: 180, proteinG: 9, carbsG: 24, fatG: 6),
  FoodItem(id: 'dal_makhani', name: 'Dal Makhani', category: 'Dals & Curries', portionLabel: '1 cup', calories: 330, proteinG: 11, carbsG: 30, fatG: 18),
  FoodItem(id: 'rajma', name: 'Rajma Masala', category: 'Dals & Curries', portionLabel: '1 cup', calories: 245, proteinG: 12, carbsG: 35, fatG: 6),
  FoodItem(id: 'chana_masala', name: 'Chana Masala', category: 'Dals & Curries', portionLabel: '1 cup', calories: 270, proteinG: 12, carbsG: 38, fatG: 8),
  FoodItem(id: 'sambar', name: 'Sambar', category: 'Dals & Curries', portionLabel: '1 cup', calories: 150, proteinG: 7, carbsG: 22, fatG: 4),
  FoodItem(id: 'rasam', name: 'Rasam', category: 'Dals & Curries', portionLabel: '1 cup', calories: 65, proteinG: 3, carbsG: 11, fatG: 1),
  FoodItem(id: 'palak_paneer', name: 'Palak Paneer', category: 'Dals & Curries', portionLabel: '1 cup', calories: 270, proteinG: 13, carbsG: 12, fatG: 19),
  FoodItem(id: 'paneer_butter_masala', name: 'Paneer Butter Masala', category: 'Dals & Curries', portionLabel: '1 cup', calories: 350, proteinG: 14, carbsG: 16, fatG: 25),
  FoodItem(id: 'shahi_paneer', name: 'Shahi Paneer', category: 'Dals & Curries', portionLabel: '1 cup', calories: 340, proteinG: 13, carbsG: 15, fatG: 24),
  FoodItem(id: 'mixed_veg', name: 'Mixed Veg Curry', category: 'Dals & Curries', portionLabel: '1 cup', calories: 180, proteinG: 5, carbsG: 18, fatG: 10),
  FoodItem(id: 'aloo_gobi', name: 'Aloo Gobi', category: 'Dals & Curries', portionLabel: '1 cup', calories: 200, proteinG: 5, carbsG: 24, fatG: 10),
  FoodItem(id: 'bhindi_masala', name: 'Bhindi Masala', category: 'Dals & Curries', portionLabel: '1 cup', calories: 175, proteinG: 4, carbsG: 16, fatG: 11),
  FoodItem(id: 'baingan_bharta', name: 'Baingan Bharta', category: 'Dals & Curries', portionLabel: '1 cup', calories: 160, proteinG: 4, carbsG: 18, fatG: 9),

  // ---------- Non-veg ----------
  FoodItem(id: 'chicken_curry', name: 'Chicken Curry', category: 'Non-veg', portionLabel: '1 cup', calories: 290, proteinG: 25, carbsG: 8, fatG: 18),
  FoodItem(id: 'butter_chicken', name: 'Butter Chicken', category: 'Non-veg', portionLabel: '1 cup', calories: 340, proteinG: 24, carbsG: 12, fatG: 22),
  FoodItem(id: 'chicken_tikka', name: 'Chicken Tikka', category: 'Non-veg', portionLabel: '4 pieces', calories: 220, proteinG: 30, carbsG: 4, fatG: 9),
  FoodItem(id: 'egg_curry', name: 'Egg Curry', category: 'Non-veg', portionLabel: '1 cup (2 eggs)', calories: 240, proteinG: 14, carbsG: 8, fatG: 17),
  FoodItem(id: 'boiled_egg', name: 'Boiled Egg', category: 'Non-veg', portionLabel: '1 egg', calories: 78, proteinG: 6, carbsG: 0.6, fatG: 5),
  FoodItem(id: 'fish_curry', name: 'Fish Curry', category: 'Non-veg', portionLabel: '1 cup', calories: 230, proteinG: 22, carbsG: 6, fatG: 13),
  FoodItem(id: 'mutton_curry', name: 'Mutton Curry', category: 'Non-veg', portionLabel: '1 cup', calories: 360, proteinG: 26, carbsG: 6, fatG: 26),

  // ---------- Breakfast ----------
  FoodItem(id: 'idli', name: 'Idli', category: 'Breakfast', portionLabel: '2 pieces', calories: 116, proteinG: 4, carbsG: 24, fatG: 0.6),
  FoodItem(id: 'plain_dosa', name: 'Plain Dosa', category: 'Breakfast', portionLabel: '1 piece', calories: 168, proteinG: 4, carbsG: 28, fatG: 4),
  FoodItem(id: 'masala_dosa', name: 'Masala Dosa', category: 'Breakfast', portionLabel: '1 piece', calories: 290, proteinG: 6, carbsG: 42, fatG: 11),
  FoodItem(id: 'medu_vada', name: 'Medu Vada', category: 'Breakfast', portionLabel: '2 pieces', calories: 200, proteinG: 6, carbsG: 24, fatG: 9),
  FoodItem(id: 'upma', name: 'Upma', category: 'Breakfast', portionLabel: '1 cup', calories: 250, proteinG: 6, carbsG: 38, fatG: 8),
  FoodItem(id: 'poha', name: 'Poha', category: 'Breakfast', portionLabel: '1 cup', calories: 270, proteinG: 5, carbsG: 45, fatG: 8),
  FoodItem(id: 'aloo_sabzi', name: 'Aloo Sabzi', category: 'Breakfast', portionLabel: '1 cup', calories: 180, proteinG: 4, carbsG: 26, fatG: 7),

  // ---------- Snacks ----------
  FoodItem(id: 'samosa', name: 'Samosa', category: 'Snacks', portionLabel: '1 piece', calories: 260, proteinG: 4, carbsG: 28, fatG: 14),
  FoodItem(id: 'pakora', name: 'Pakora / Bhaji', category: 'Snacks', portionLabel: '100 g', calories: 315, proteinG: 7, carbsG: 30, fatG: 18),
  FoodItem(id: 'dhokla', name: 'Dhokla', category: 'Snacks', portionLabel: '2 pieces', calories: 160, proteinG: 6, carbsG: 26, fatG: 4),
  FoodItem(id: 'vada_pav', name: 'Vada Pav', category: 'Snacks', portionLabel: '1 piece', calories: 290, proteinG: 7, carbsG: 42, fatG: 11),
  FoodItem(id: 'pav_bhaji', name: 'Pav Bhaji', category: 'Snacks', portionLabel: '1 plate', calories: 400, proteinG: 9, carbsG: 52, fatG: 17),
  FoodItem(id: 'pani_puri', name: 'Pani Puri', category: 'Snacks', portionLabel: '6 pieces', calories: 180, proteinG: 3, carbsG: 32, fatG: 5),
  FoodItem(id: 'bhel_puri', name: 'Bhel Puri', category: 'Snacks', portionLabel: '1 cup', calories: 230, proteinG: 5, carbsG: 38, fatG: 7),
  FoodItem(id: 'chole_bhature', name: 'Chole Bhature', category: 'Snacks', portionLabel: '1 plate', calories: 450, proteinG: 12, carbsG: 55, fatG: 20),

  // ---------- Sweets ----------
  FoodItem(id: 'gulab_jamun', name: 'Gulab Jamun', category: 'Sweets', portionLabel: '1 piece', calories: 150, proteinG: 2, carbsG: 22, fatG: 6),
  FoodItem(id: 'rasgulla', name: 'Rasgulla', category: 'Sweets', portionLabel: '1 piece', calories: 106, proteinG: 2, carbsG: 22, fatG: 1.5),
  FoodItem(id: 'jalebi', name: 'Jalebi', category: 'Sweets', portionLabel: '1 piece (30 g)', calories: 150, proteinG: 1, carbsG: 25, fatG: 5),
  FoodItem(id: 'kheer', name: 'Kheer', category: 'Sweets', portionLabel: '1 cup', calories: 250, proteinG: 6, carbsG: 40, fatG: 8),
  FoodItem(id: 'gajar_halwa', name: 'Gajar Halwa', category: 'Sweets', portionLabel: '1/2 cup', calories: 270, proteinG: 4, carbsG: 36, fatG: 13),
  FoodItem(id: 'besan_ladoo', name: 'Besan Ladoo', category: 'Sweets', portionLabel: '1 piece', calories: 185, proteinG: 3, carbsG: 20, fatG: 11),
  FoodItem(id: 'barfi', name: 'Barfi', category: 'Sweets', portionLabel: '1 piece', calories: 165, proteinG: 3, carbsG: 18, fatG: 9),

  // ---------- Drinks & Sides ----------
  FoodItem(id: 'masala_chai', name: 'Masala Chai', category: 'Drinks & Sides', portionLabel: '1 cup', calories: 90, proteinG: 2, carbsG: 12, fatG: 3),
  FoodItem(id: 'sweet_lassi', name: 'Sweet Lassi', category: 'Drinks & Sides', portionLabel: '1 glass', calories: 220, proteinG: 6, carbsG: 30, fatG: 8),
  FoodItem(id: 'chaas', name: 'Buttermilk / Chaas', category: 'Drinks & Sides', portionLabel: '1 glass', calories: 60, proteinG: 3, carbsG: 6, fatG: 2),
  FoodItem(id: 'filter_coffee', name: 'Filter Coffee', category: 'Drinks & Sides', portionLabel: '1 cup', calories: 90, proteinG: 3, carbsG: 11, fatG: 3),
  FoodItem(id: 'curd', name: 'Plain Curd / Yogurt', category: 'Drinks & Sides', portionLabel: '1 cup', calories: 100, proteinG: 8, carbsG: 11, fatG: 4),
  FoodItem(id: 'raita', name: 'Raita', category: 'Drinks & Sides', portionLabel: '1/2 cup', calories: 90, proteinG: 4, carbsG: 7, fatG: 5),
  FoodItem(id: 'papad', name: 'Papad', category: 'Drinks & Sides', portionLabel: '1 piece', calories: 40, proteinG: 2, carbsG: 6, fatG: 1),
  FoodItem(id: 'pickle', name: 'Pickle (Achar)', category: 'Drinks & Sides', portionLabel: '1 tbsp', calories: 30, proteinG: 0.3, carbsG: 2, fatG: 2.5),
  FoodItem(id: 'ghee', name: 'Ghee', category: 'Drinks & Sides', portionLabel: '1 tsp', calories: 45, proteinG: 0, carbsG: 0, fatG: 5),
  FoodItem(id: 'banana', name: 'Banana', category: 'Drinks & Sides', portionLabel: '1 medium', calories: 105, proteinG: 1, carbsG: 27, fatG: 0.4),
];

/// Distinct categories in library order, with "All" first.
List<String> foodCategories() {
  final seen = <String>{};
  final cats = <String>['All'];
  for (final f in kFoodLibrary) {
    if (seen.add(f.category)) cats.add(f.category);
  }
  return cats;
}

/// Case-insensitive search by name, optionally filtered by category.
List<FoodItem> searchFoods(String query, {String category = 'All'}) {
  final q = query.trim().toLowerCase();
  return kFoodLibrary.where((f) {
    final catOk = category == 'All' || f.category == category;
    final nameOk = q.isEmpty || f.name.toLowerCase().contains(q);
    return catOk && nameOk;
  }).toList();
}
