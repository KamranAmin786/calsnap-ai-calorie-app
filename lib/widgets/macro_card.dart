import 'package:flutter/material.dart';

import '../theme.dart';
import 'count_up.dart';
import 'ring.dart';

/// Grams left for one macro, with a small ring.
class MacroCard extends StatelessWidget {
  const MacroCard({
    super.key,
    required this.label,
    required this.left,
    required this.progress,
    required this.color,
    required this.icon,
  });

  final String label;
  final int left;
  final double progress;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CountUp(
            value: left,
            suffix: 'g',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: ink),
          ),
          Text('$label left', style: const TextStyle(fontSize: 12, color: grey, fontWeight: FontWeight.w500)),
          const SizedBox(height: 14),
          Center(
            child: Ring(
              progress: progress,
              color: color,
              size: 62,
              child: Icon(icon, color: color, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}
