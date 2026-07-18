import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'screens/home/home_screen.dart';

void main() {
  runApp(const RoadMonitoringApp());
}

class RoadMonitoringApp extends StatelessWidget {
  const RoadMonitoringApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Road Construction Monitoring',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}