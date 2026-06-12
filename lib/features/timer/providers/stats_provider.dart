import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart'; // Tu provider de SharedPreferences

class MonthlyStats {
  final int routinesCompleted;
  final int targetRoutines; // Tu meta mensual

  MonthlyStats({required this.routinesCompleted, required this.targetRoutines});
}

class StatsNotifier extends Notifier<MonthlyStats> {
  @override
  MonthlyStats build() {
    final prefs = ref.read(sharedPrefsProvider);

    final savedMonth = prefs.getInt('currentMonth') ?? DateTime.now().month;
    final currentMonth = DateTime.now().month;

    // Cargamos la meta guardada, o 50 por defecto
    final savedTarget = prefs.getInt('targetRoutines') ?? 50;

    // Si cambiamos de mes, reiniciamos el contador a 0
    if (savedMonth != currentMonth) {
      prefs.setInt('currentMonth', currentMonth);
      prefs.setInt('monthlyRoutines', 0);
      return MonthlyStats(routinesCompleted: 0, targetRoutines: savedTarget);
    }

    // Si seguimos en el mismo mes, cargamos las rutinas hechas
    final routines = prefs.getInt('monthlyRoutines') ?? 0;
    return MonthlyStats(
      routinesCompleted: routines,
      targetRoutines: savedTarget,
    );
  }

  // Nuevo método para actualizar la meta
  void updateTarget(int newTarget) {
    final prefs = ref.read(sharedPrefsProvider);
    prefs.setInt('targetRoutines', newTarget);
    state = MonthlyStats(
      routinesCompleted: state.routinesCompleted,
      targetRoutines: newTarget,
    );
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
    state = MonthlyStats(
      routinesCompleted: newTotal,
      targetRoutines: state.targetRoutines,
    );
  }
}

final statsProvider = NotifierProvider<StatsNotifier, MonthlyStats>(() {
  return StatsNotifier();
});
