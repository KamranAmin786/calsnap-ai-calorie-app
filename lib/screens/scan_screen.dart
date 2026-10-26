import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../services/food_ai.dart';
import '../theme.dart';
import '../widgets/result_sheet.dart';
import '../widgets/scan_overlay.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key, required this.photo, required this.mimeType});

  final Uint8List photo;
  final String mimeType;

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with SingleTickerProviderStateMixin {
  late final _scan = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  Meal? _meal;
  String? _error;

  @override
  void initState() {
    super.initState();
    _analyze();
  }

  Future<void> _analyze() async {
    setState(() => _error = null);
    try {
      // Let the scan animation run at least 2.5 seconds, even if the AI is faster.
      final results = await Future.wait([
        FoodAI.analyze(widget.photo, widget.mimeType),
        Future.delayed(const Duration(milliseconds: 2500)),
      ]);
      if (mounted) setState(() => _meal = results.first as Meal);
    } catch (e) {
      if (mounted) setState(() => _error = 'Could not read this photo. Try again.');
    }
  }

  @override
  void dispose() {
    _scan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final done = _meal != null;
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final h = constraints.maxHeight;
          return Stack(
            children: [
              // The photo shrinks to the top when the result arrives.
              AnimatedPositioned(
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOutCubic,
                left: 0,
                right: 0,
                top: 0,
                bottom: done ? h * 0.52 : 0,
                child: Image.memory(widget.photo, fit: BoxFit.cover),
              ),
              if (!done) ...[
                Positioned.fill(child: ScanOverlay(animation: _scan)),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 70,
                  child: Center(
                    child: _error == null ? const _StatusChip() : _retry(),
                  ),
                ),
              ],
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedSlide(
                  offset: done ? Offset.zero : const Offset(0, 1),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                  child: done
                      ? ResultSheet(meal: _meal!, onLog: () => Navigator.pop(context, _meal))
                      : const SizedBox(height: 300),
                ),
              ),
              Positioned(
                top: MediaQuery.paddingOf(context).top + 12,
                left: 16,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.close_rounded, color: ink),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _retry() {
    return GestureDetector(
      onTap: _analyze,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
        child: Text(_error!, style: const TextStyle(fontWeight: FontWeight.w700, color: ink)),
      ),
    );
  }
}

/// Cycles through a few short messages while the AI is thinking.
class _StatusChip extends StatefulWidget {
  const _StatusChip();

  @override
  State<_StatusChip> createState() => _StatusChipState();
}

class _StatusChipState extends State<_StatusChip> {
  static const _messages = ['Finding the food...', 'Counting calories...', 'Checking the macros...'];
  int _index = 0;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 1300), (_) {
      setState(() => _index = (_index + 1) % _messages.length);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(strokeWidth: 2.5, color: green),
          ),
          const SizedBox(width: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              _messages[_index],
              key: ValueKey(_index),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: ink),
            ),
          ),
        ],
      ),
    );
  }
}
