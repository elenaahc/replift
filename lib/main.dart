import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme.dart';
import 'features/timer/presentation/screens/timer_screen.dart';

// 1. Creamos un Provider global para poder leer las preferencias desde cualquier parte
final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Se debe sobreescribir en el main');
});

void main() async {
  // 2. Aseguramos que el motor de Flutter esté listo antes de usar código nativo
  WidgetsFlutterBinding.ensureInitialized();

  // 3. Cargamos la memoria del teléfono
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        // 4. Inyectamos la instancia real que acabamos de cargar
        sharedPrefsProvider.overrideWithValue(prefs),
      ],
      child: const GymTimerApp(),
    ),
  );
}

class GymTimerApp extends StatelessWidget {
  const GymTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Timer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const TimerScreen(),
    );
  }
}
