import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/food_library.dart';
import '../../models/food_item.dart';
import '../../providers/app_data_provider.dart';

class FoodSearchScreen extends ConsumerStatefulWidget {
  final String dayKey;
  const FoodSearchScreen({super.key, required this.dayKey});

  @override
  ConsumerState<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends ConsumerState<FoodSearchScreen> {
  String _query = '';
  String _category = 'All';

  @override
  Widget build(BuildContext context) {
    final categories = foodCategories();
    final results = searchFoods(_query, category: _category);

    return Scaffold(
      appBar: AppBar(title: const Text('Add food')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              autofocus: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search e.g. dosa, dal, roti…',
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final c = categories[i];
                return ChoiceChip(
                  label: Text(c),
                  selected: _category == c,
                  onSelected: (_) => setState(() => _category = c),
                );
              },
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: results.isEmpty
                ? const Center(child: Text('No matching foods'))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: results.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final f = results[i];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(f.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(
                            '${f.portionLabel} · ${f.calories.round()} kcal · '
                            'P${f.proteinG.round()} C${f.carbsG.round()} F${f.fatG.round()}'),
                        trailing: FilledButton.tonal(
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(64, 40),
                          ),
                          onPressed: () => _add(f),
                          child: const Text('Add'),
                        ),
                        onTap: () => _addWithQuantity(f),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _add(FoodItem f) {
    ref.read(appDataProvider.notifier).addFood(f, 1, dayKey: widget.dayKey);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added ${f.name}'), duration: const Duration(milliseconds: 900)),
    );
  }

  Future<void> _addWithQuantity(FoodItem f) async {
    final controller = TextEditingController(text: '1');
    final qty = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(f.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${f.portionLabel} = ${f.calories.round()} kcal'),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              autofocus: true,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Portions'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(context, double.tryParse(controller.text.trim())),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (qty != null && qty > 0) {
      ref.read(appDataProvider.notifier).addFood(f, qty, dayKey: widget.dayKey);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added $qty × ${f.name}')),
        );
      }
    }
  }
}
