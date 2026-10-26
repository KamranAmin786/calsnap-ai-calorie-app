import 'dart:typed_data';

import 'package:flutter/material.dart';

/// One eaten meal: what the AI found in the photo.
class Meal {
  const Meal({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.healthScore,
    required this.ingredients,
    required this.time,
    this.photo,
    this.asset,
  });

  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final int healthScore;
  final List<String> ingredients;
  final DateTime time;
  final Uint8List? photo;
  final String? asset;

  factory Meal.fromJson(Map<String, dynamic> json, Uint8List photo) {
    return Meal(
      name: json['name'],
      calories: (json['calories'] as num).round(),
      protein: (json['protein'] as num).round(),
      carbs: (json['carbs'] as num).round(),
      fat: (json['fat'] as num).round(),
      healthScore: (json['healthScore'] as num).round().clamp(1, 10),
      ingredients: List<String>.from(json['ingredients']),
      time: DateTime.now(),
      photo: photo,
    );
  }

  ImageProvider get image => photo != null ? MemoryImage(photo!) : AssetImage(asset!);
}
