import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart'; // Tu provider de SharedPreferences

class MonthlyStats {
  final int routinesCompleted;
  final int targetRoutines = 50; // Tu meta mensual

  MonthlyStats({required this.routinesCompleted});
}

class StatsNotifier extends Notifier<MonthlyStats> {
  @override
  MonthlyStats build() {
    final prefs = ref.read(sharedPrefsProvider);

    final savedMonth = prefs.getInt('currentMonth') ?? DateTime.now().month;
    final currentMonth = DateTime.now().month;

    // Si cambiamos de mes, reiniciamos el contador a 0
    if (savedMonth != currentMonth) {
      prefs.setInt('currentMonth', currentMonth);
      prefs.setInt('monthlyRoutines', 0);
      return MonthlyStats(routinesCompleted: 0);
    }

    // Si seguimos en el mismo mes, cargamos las rutinas hechas
    final routines = prefs.getInt('monthlyRoutines') ?? 0;
    return MonthlyStats(routinesCompleted: routines);
  }

  void addCompletedRoutine() {
    final prefs = ref.read(sharedPrefsProvider);
    final currentMonth = DateTime.now().month;

    // Verificación de seguridad por si cambiaste de mes justo entrenando a medianoche
    int newTotal;
    if (prefs.getInt('currentMonth') != currentMonth) {
      prefs.setInt('currentMonth', currentMonth);
      newTotal = 1;
    } else {
      newTotal = state.routinesCompleted + 1;
    }

    prefs.setInt('monthlyRoutines', newTotal);
    state = MonthlyStats(routinesCompleted: newTotal);
  }
}

final statsProvider = NotifierProvider<StatsNotifier, MonthlyStats>(() {
  return StatsNotifier();
});
