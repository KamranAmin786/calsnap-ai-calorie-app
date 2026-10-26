import 'package:flutter/material.dart';

import '../models/meal.dart';

/// Today's meals and totals. Screens rebuild when a meal is added.
class DayLog extends ChangeNotifier {
  static const goalCalories = 2200;
  static const goalProtein = 150;
  static const goalCarbs = 250;
  static const goalFat = 70;

  final List<Meal> _meals = [
    Meal(
      name: 'Veggie Grain Bowl',
      calories: 520,
      protein: 18,
      carbs: 64,
      fat: 21,
      healthScore: 9,
      ingredients: const ['Quinoa', 'Carrots', 'Broccoli', 'Peppers'],
      time: DateTime.now().copyWith(hour: 13, minute: 5),
      asset: 'assets/meals/veggie_bowl.jpg',
    ),
    Meal(
      name: 'Avocado Toast',
      calories: 340,
      protein: 12,
      carbs: 32,
      fat: 19,
      healthScore: 8,
      ingredients: const ['Sourdough', 'Avocado', 'Spinach'],
      time: DateTime.now().copyWith(hour: 8, minute: 15),
      asset: 'assets/meals/avocado_toast.jpg',
    ),
  ];

  List<Meal> get meals => List.unmodifiable(_meals);

  int get calories => _meals.fold(0, (sum, m) => sum + m.calories);
  int get protein => _meals.fold(0, (sum, m) => sum + m.protein);
  int get carbs => _meals.fold(0, (sum, m) => sum + m.carbs);
  int get fat => _meals.fold(0, (sum, m) => sum + m.fat);

  void add(Meal meal) {
    _meals.insert(0, meal);
    notifyListeners();
  }
}

/// Makes the day log available to every screen below it.
class DayScope extends InheritedNotifier<DayLog> {
  const DayScope({super.key, required DayLog log, required super.child})
      : super(notifier: log);

  static DayLog of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DayScope>()!.notifier!;
}
