import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme.dart';
import 'features/timer/presentation/screens/timer_screen.dart';

void main() {
  runApp(
    // ProviderScope es necesario para que el estado global funcione en toda la app
    const ProviderScope(child: GymTimerApp()),
  );
}

class GymTimerApp extends StatelessWidget {
  const GymTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Timer',
      debugShowCheckedModeBanner: false, // Quitamos la etiqueta de "DEBUG"
      theme: AppTheme.darkTheme, // Aplicamos nuestro tema optimizado
      home: const TimerScreen(),
    );
  }
}
