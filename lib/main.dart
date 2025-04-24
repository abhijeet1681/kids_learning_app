import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kids Learning App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFC8E6C9), // Mint Green background
        primaryColor: const Color(0xFFFF6F61), // Coral Pink
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 219, 247, 79), // Bright Sky Blue
          ),
          bodyMedium: TextStyle(
            fontSize: 18,
            color: Color.fromARGB(255, 236, 247, 79), // Bright Sky Blue
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFF6F61), // Coral Pink
          foregroundColor: Colors.white, // White text
          centerTitle: true,
          elevation: 4,
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: Color(0xFF4FC3F7), // Bright Sky Blue
          unselectedLabelColor: Colors.white, // Soft white
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: Color(0xFFFFB74D), width: 3), // Orange Accent
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFF6F61), // Coral Pink
            foregroundColor: Colors.white, // White text
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
