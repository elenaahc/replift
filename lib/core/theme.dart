import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      // Fondo negro puro (True Black) para ahorrar batería en pantallas OLED
      scaffoldBackgroundColor: Colors.black,
      brightness: Brightness.dark,

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),

      textTheme: const TextTheme(
        // Configuraciones base para nuestros textos
        displayLarge: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: Colors.white70),
      ),
    );
  }
}
