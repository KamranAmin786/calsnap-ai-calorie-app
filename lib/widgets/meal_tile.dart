import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../theme.dart';

/// A logged meal: photo, name, time, calories and macros.
class MealTile extends StatelessWidget {
  const MealTile({super.key, required this.meal});

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    final time = TimeOfDay.fromDateTime(meal.time).format(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image(image: meal.image, width: 76, height: 76, fit: BoxFit.cover),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        meal.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: ink),
                      ),
                    ),
                    Text(time, style: const TextStyle(fontSize: 12, color: grey)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department_rounded, size: 16, color: ink),
                    Text(
                      ' ${meal.calories} kcal',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: ink),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _macro('${meal.protein}g', proteinColor),
                    _macro('${meal.carbs}g', carbsColor),
                    _macro('${meal.fat}g', fatColor),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _macro(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 5),
          Text(text, style: const TextStyle(fontSize: 12, color: grey, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
