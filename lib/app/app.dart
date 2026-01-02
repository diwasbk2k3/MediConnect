import 'package:flutter/material.dart';
import 'package:mediconnect/features/splash/presentation/pages/splash_screen.dart';
import 'package:mediconnect/app/theme/theme_data.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      home: SplashScreen()
    );
  }
}