import 'package:flutter/material.dart';

const background = Color(0xFFF5F5F0);
const ink = Color(0xFF15151A);
const grey = Color(0xFF8E8E99);
const green = Color(0xFF22C55E);
const proteinColor = Color(0xFFFF5A5F);
const carbsColor = Color(0xFFFFB020);
const fatColor = Color(0xFF3B82F6);

final appTheme = ThemeData(
  fontFamily: 'Inter',
  scaffoldBackgroundColor: background,
  colorScheme: ColorScheme.fromSeed(seedColor: green, primary: ink),
);
