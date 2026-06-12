import 'package:flutter/material.dart';

// Nuestro selector de Eras
enum ThemeEra { reputation, midnights, red, dynamite, butter }

class AppThemes {
  static ThemeData getTheme(ThemeEra era) {
    switch (era) {
      case ThemeEra.midnights:
        return ThemeData(
          scaffoldBackgroundColor: const Color(
            0xFF0F172A,
          ), // Azul marino muy oscuro
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFB39DDB), // Lavanda (Trabajo)
            secondary: Color(0xFF81D4FA), // Azul pastel (Descanso)
            surface: Color(0xFF1E293B), // Indigo oscuro para los modales
          ),
        );
      case ThemeEra.red:
        return ThemeData(
          scaffoldBackgroundColor: const Color(
            0xFF4A0000,
          ), // Rojo profundo (casi vino), // Negro carbón
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFE63946), // Rojo Taylor (Trabajo)
            secondary: Color(0xFFF1FAEE), // Crema (Descanso)
            surface: Color(0xFF2D2D2D), // Gris oscuro
          ),
        );

      case ThemeEra.dynamite:
        return ThemeData(
          scaffoldBackgroundColor: const Color(
            0xFF2D1B4E,
          ), // Morado profundo BTS
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFFF80AB), // Rosa neón (Trabajo)
            secondary: Color(0xFF18FFFF), // Cian brillante (Descanso)
            surface: Color(0xFF4A148C), // Morado intenso para modales
          ),
        );

      case ThemeEra.butter:
        return ThemeData(
          // Un naranja vibrante y cálido que se siente como energía pura
          scaffoldBackgroundColor: const Color(0xFFD84315),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFFFD700), // Tu amarillo Butter vibrante
            secondary: Color(0xFFFFFFFF), // Blanco para contraste máximo
            // Un naranja un poco más intenso/oscuro para los modales
            surface: Color(0xFFBF360C),
          ),
        );

      case ThemeEra.reputation:
        return ThemeData(
          scaffoldBackgroundColor: Colors.black, // True Black
          colorScheme: ColorScheme.dark(
            primary: Colors.redAccent, // Rojo (Trabajo)
            secondary: Colors.greenAccent, // Verde (Descanso)
            surface: Color(0xFF212121), // Gris oscuro para modales
          ),
        );
    }
  }
}
