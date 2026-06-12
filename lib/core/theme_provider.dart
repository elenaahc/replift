import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart'; // Tu provider de SharedPreferences
import 'theme.dart';

class ThemeNotifier extends Notifier<ThemeEra> {
  @override
  ThemeEra build() {
    final prefs = ref.read(sharedPrefsProvider);
    // Leemos el tema guardado. Si no hay, empezamos en Reputation
    final savedTheme = prefs.getString('app_theme') ?? ThemeEra.reputation.name;

    // Buscamos a qué Era corresponde el texto guardado
    return ThemeEra.values.firstWhere(
      (e) => e.name == savedTheme,
      orElse: () => ThemeEra.reputation,
    );
  }

  void changeTheme(ThemeEra newEra) {
    state = newEra;
    ref.read(sharedPrefsProvider).setString('app_theme', newEra.name);
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeEra>(() {
  return ThemeNotifier();
});
