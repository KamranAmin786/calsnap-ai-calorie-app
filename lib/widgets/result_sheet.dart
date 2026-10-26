import 'package:flutter/material.dart';

import '../data/day_log.dart';
import '../models/meal.dart';
import '../theme.dart';
import 'count_up.dart';
import 'fade_slide.dart';

/// What the AI found: name, calories, macros, health score and ingredients.
class ResultSheet extends StatelessWidget {
  const ResultSheet({super.key, required this.meal, required this.onLog});

  final Meal meal;
  final VoidCallback onLog;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 28),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeSlide(
            delay: 150,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    meal.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: ink),
                  ),
                ),
                _HealthChip(score: meal.healthScore),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FadeSlide(
            delay: 250,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  const Icon(Icons.local_fire_department_rounded, color: ink, size: 30),
                  const SizedBox(width: 8),
                  CountUp(
                    value: meal.calories,
                    style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: ink),
                  ),
                  const Text(' kcal', style: TextStyle(fontSize: 16, color: grey, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FadeSlide(
            delay: 350,
            child: Row(
              children: [
                _MacroBar(label: 'Protein', grams: meal.protein, goal: DayLog.goalProtein, color: proteinColor),
                const SizedBox(width: 12),
                _MacroBar(label: 'Carbs', grams: meal.carbs, goal: DayLog.goalCarbs, color: carbsColor),
                const SizedBox(width: 12),
                _MacroBar(label: 'Fat', grams: meal.fat, goal: DayLog.goalFat, color: fatColor),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < meal.ingredients.length; i++)
                FadeSlide(
                  delay: 450 + 70 * i,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE6E6E0)),
                    ),
                    child: Text(
                      meal.ingredients[i],
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: ink),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 22),
          FadeSlide(
            delay: 650,
            child: GestureDetector(
              onTap: onLog,
              child: Container(
                height: 58,
                decoration: BoxDecoration(color: ink, borderRadius: BorderRadius.circular(20)),
                child: const Center(
                  child: Text(
                    'Log this meal',
                    style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MacroBar extends StatelessWidget {
  const _MacroBar({required this.label, required this.grams, required this.goal, required this.color});

  final String label;
  final int grams;
  final int goal;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: grey, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          CountUp(
            value: grams,
            suffix: 'g',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: ink),
          ),
          const SizedBox(height: 6),
          Container(
            height: 7,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
            alignment: Alignment.centerLeft,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: (grams / goal).clamp(0.04, 1)),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutCubic,
              builder: (context, v, _) => FractionallySizedBox(
                widthFactor: v,
                child: Container(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HealthChip extends StatelessWidget {
  const _HealthChip({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    final color = score >= 7 ? green : score >= 4 ? carbsColor : proteinColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(Icons.favorite_rounded, color: color, size: 16),
          const SizedBox(width: 4),
          Text('$score/10', style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
