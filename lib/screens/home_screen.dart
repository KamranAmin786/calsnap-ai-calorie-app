import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data/day_log.dart';
import '../models/meal.dart';
import '../theme.dart';
import '../widgets/count_up.dart';
import '../widgets/fade_slide.dart';
import '../widgets/macro_card.dart';
import '../widgets/meal_tile.dart';
import '../widgets/ring.dart';
import 'scan_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _scan(BuildContext context, ImageSource source) async {
    final file = await ImagePicker().pickImage(source: source, maxWidth: 1024, imageQuality: 85);
    if (file == null || !context.mounted) return;
    final photo = await file.readAsBytes();
    if (!context.mounted) return;
    final meal = await Navigator.of(context).push<Meal>(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (_, _, _) => ScanScreen(photo: photo, mimeType: file.mimeType ?? 'image/jpeg'),
        transitionsBuilder: (_, animation, _, child) => FadeTransition(opacity: animation, child: child),
      ),
    );
    if (meal != null && context.mounted) DayScope.of(context).add(meal);
  }

  void _pickSource(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (sheet) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _sourceButton(sheet, Icons.photo_camera_rounded, 'Take a photo', () {
              Navigator.pop(sheet);
              _scan(context, ImageSource.camera);
            }),
            const SizedBox(height: 12),
            _sourceButton(sheet, Icons.photo_library_rounded, 'Choose from gallery', () {
              Navigator.pop(sheet);
              _scan(context, ImageSource.gallery);
            }),
          ],
        ),
      ),
    );
  }

  Widget _sourceButton(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(18)),
        child: Row(
          children: [
            Icon(icon, color: ink),
            const SizedBox(width: 14),
            Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: ink)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final log = DayScope.of(context);
    final left = (DayLog.goalCalories - log.calories).clamp(0, DayLog.goalCalories);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          children: [
            const FadeSlide(child: _Header()),
            const SizedBox(height: 18),
            const FadeSlide(delay: 100, child: _WeekStrip()),
            const SizedBox(height: 18),
            FadeSlide(
              delay: 200,
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(26)),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CountUp(
                            value: left,
                            style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w800, color: ink, height: 1),
                          ),
                          const SizedBox(height: 6),
                          const Text('Calories left', style: TextStyle(fontSize: 15, color: grey, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    Ring(
                      progress: log.calories / DayLog.goalCalories,
                      color: green,
                      size: 112,
                      stroke: 11,
                      child: const Icon(Icons.local_fire_department_rounded, color: ink, size: 34),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            FadeSlide(
              delay: 300,
              child: Row(
                children: [
                  Expanded(
                    child: MacroCard(
                      label: 'Protein',
                      left: (DayLog.goalProtein - log.protein).clamp(0, 999),
                      progress: log.protein / DayLog.goalProtein,
                      color: proteinColor,
                      icon: Icons.egg_alt_rounded,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: MacroCard(
                      label: 'Carbs',
                      left: (DayLog.goalCarbs - log.carbs).clamp(0, 999),
                      progress: log.carbs / DayLog.goalCarbs,
                      color: carbsColor,
                      icon: Icons.bakery_dining_rounded,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: MacroCard(
                      label: 'Fat',
                      left: (DayLog.goalFat - log.fat).clamp(0, 999),
                      progress: log.fat / DayLog.goalFat,
                      color: fatColor,
                      icon: Icons.water_drop_rounded,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const FadeSlide(
              delay: 400,
              child: Text("Today's meals", style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: ink)),
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < log.meals.length; i++)
              FadeSlide(
                key: ValueKey(log.meals[i].time),
                delay: 450 + 80 * i,
                child: MealTile(meal: log.meals[i]),
              ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: () => _pickSource(context),
        child: Container(
          height: 62,
          padding: const EdgeInsets.symmetric(horizontal: 28),
          decoration: BoxDecoration(
            color: ink,
            borderRadius: BorderRadius.circular(31),
            boxShadow: [BoxShadow(color: ink.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.photo_camera_rounded, color: Colors.white),
              SizedBox(width: 10),
              Text('Scan food', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'Cal', style: TextStyle(color: ink)),
              TextSpan(text: 'Snap', style: TextStyle(color: green)),
            ],
          ),
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: const Row(
            children: [
              Icon(Icons.local_fire_department_rounded, color: Color(0xFFFF8A00), size: 20),
              SizedBox(width: 4),
              Text('7', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: ink)),
            ],
          ),
        ),
      ],
    );
  }
}

class _WeekStrip extends StatelessWidget {
  const _WeekStrip();

  static const _names = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final monday = today.subtract(Duration(days: today.weekday - 1));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var i = 0; i < 7; i++)
          _day(_names[i], monday.add(Duration(days: i)).day, i == today.weekday - 1),
      ],
    );
  }

  Widget _day(String name, int date, bool selected) {
    return Container(
      width: 44,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: selected ? ink : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(name, style: TextStyle(fontSize: 12, color: selected ? Colors.white70 : grey, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('$date', style: TextStyle(fontSize: 16, color: selected ? Colors.white : ink, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
