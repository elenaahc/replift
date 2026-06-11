import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_app/main.dart';
import 'package:wakelock_plus/wakelock_plus.dart'; // Importamos wakelock
import '../services/alert_service.dart';
import 'timer_state.dart';

class TimerNotifier extends Notifier<TimerState> {
  Timer? _timer;
  late final AlertService _alertService;

  // Ahora usamos "late" porque los inicializaremos en el build
  late int workTime;
  late int restTime;
  late int initialSets;

  @override
  TimerState build() {
    _alertService = AlertService(); // Inicializamos el servicio de alertas

    // 1. Leemos las preferencias directamente desde el Provider
    final prefs = ref.read(sharedPrefsProvider);

    // 2. Cargamos los datos. Si es nulo (primera vez que abres la app), usamos un valor por defecto
    workTime = prefs.getInt('workTime') ?? 60;
    restTime = prefs.getInt('restTime') ?? 60;
    initialSets = prefs.getInt('initialSets') ?? 4;

    return TimerState(
      timeRemaining: workTime,
      isWorkPhase: true,
      setsRemaining: initialSets,
    );
  }

  // 3. Actualizamos la función para que guarde físicamente los datos
  void updateSettings({
    required int work,
    required int rest,
    required int sets,
  }) {
    workTime = work;
    restTime = rest;
    initialSets = sets;

    final prefs = ref.read(sharedPrefsProvider);
    // Guardamos en la memoria persistente
    prefs.setInt('workTime', workTime);
    prefs.setInt('restTime', restTime);
    prefs.setInt('initialSets', initialSets);

    resetTimer();
  }

  void startTimer() {
    if (state.isRunning) return;

    WakelockPlus.enable();

    state = state.copyWith(isRunning: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeRemaining > 0) {
        final newTime = state.timeRemaining - 1;
        state = state.copyWith(timeRemaining: newTime);

        // ¡La magia de tu archivo de audio!
        // Le damos play justo en el segundo 3. El primer beep corto sonará en el 3,
        // el segundo en el 2, el tercero en el 1, y el largo caerá justo en el 0.
        if (newTime == 3) {
          _alertService.playPhaseChangeAlert();
        }
      } else {
        // Llegó a 0, ejecutamos el cambio de fase visual y lógico
        _handlePhaseChange();
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    // Desactivamos Wakelock al pausar para no drenar batería innecesariamente
    WakelockPlus.disable();
    state = state.copyWith(isRunning: false);
  }

  void resetTimer() {
    _timer?.cancel();
    WakelockPlus.disable();
    state = TimerState(
      timeRemaining: workTime,
      isWorkPhase: true,
      setsRemaining: initialSets,
    );
  }

  void _handlePhaseChange() {
    if (state.isWorkPhase) {
      // Pasamos a Descanso (Ya NO llamamos a playPhaseChangeAlert aquí porque ya sonó)
      state = state.copyWith(isWorkPhase: false, timeRemaining: restTime);
    } else {
      final nextSets = state.setsRemaining - 1;

      if (nextSets > 0) {
        // Pasamos a Trabajo (Ya NO llamamos a playPhaseChangeAlert aquí)
        state = state.copyWith(
          isWorkPhase: true,
          timeRemaining: workTime,
          setsRemaining: nextSets,
        );
      } else {
        // Fin de la rutina completa -> Esta sí la dejamos para que suene distinto al final
        _alertService.playRoutineCompletedAlert();
        pauseTimer();
        resetTimer();
      }
    }
  }
}

final timerProvider = NotifierProvider<TimerNotifier, TimerState>(() {
  return TimerNotifier();
});
