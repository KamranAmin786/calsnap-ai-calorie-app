import 'package:flutter/material.dart';

import 'data/day_log.dart';
import 'screens/home_screen.dart';
import 'theme.dart';

void main() => runApp(const CalSnapApp());

class CalSnapApp extends StatefulWidget {
  const CalSnapApp({super.key});

  @override
  State<CalSnapApp> createState() => _CalSnapAppState();
}

class _CalSnapAppState extends State<CalSnapApp> {
  final _log = DayLog();

  @override
  Widget build(BuildContext context) {
    return DayScope(
      log: _log,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
