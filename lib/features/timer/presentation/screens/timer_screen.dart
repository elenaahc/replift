import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_app/features/timer/presentation/widgets/settings_modal.dart';
import 'package:gym_app/features/timer/providers/stats_provider.dart';
import 'package:gym_app/features/timer/providers/timer_notifier.dart';

class TimerScreen extends ConsumerWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Escuchamos el estado global de nuestro Provider
    final timerState = ref.watch(timerProvider);
    final stats = ref.watch(statsProvider);

    // ¡NUEVO! Escuchador de eventos únicos (como llegar a la meta)
    ref.listen<MonthlyStats>(statsProvider, (previous, next) {
      // Si justo acaba de llegar a la meta de 50:
      if (next.routinesCompleted == next.targetRoutines &&
          (previous == null ||
              previous.routinesCompleted < next.targetRoutines)) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: const Center(
              child: Text("🏆", style: TextStyle(fontSize: 60)),
            ),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "¡Meta Mensual Alcanzada!",
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  "Has completado 50 rutinas este mes. Tienes la disciplina necesaria para resistir una gira mundial completa. ¡A celebrar!",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text(
                    "¡A SEGUIR ASÍ!",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    });
    // 2. Definimos las variables que tu diseño está pidiendo
    final isWorkPhase = timerState.isWorkPhase;

    // Calculamos los minutos y segundos para que se vean como "01:05"
    final minutes = (timerState.timeRemaining / 60).floor().toString().padLeft(
      2,
      '0',
    );
    final seconds = (timerState.timeRemaining % 60).toString().padLeft(2, '0');
    final timeString = "$minutes:$seconds";

    final setsRemaining = timerState.setsRemaining;
    final isRunning = timerState.isRunning;

    final timerNotifier = ref.read(timerProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.settings,
                      size: 32,
                      color: Colors.white54,
                    ),
                    onPressed: () {
                      // Solo permitir ajustes si el temporizador está pausado
                      if (!isRunning) {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled:
                              true, // Para que no se corte en pantallas pequeñas
                          backgroundColor: Colors
                              .transparent, // El color ya se lo dimos al Container del modal
                          builder: (context) => const SettingsModal(),
                        );
                      } else {
                        // Un pequeño aviso visual si intentas configurarlo corriendo
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Pausa el temporizador para configurar",
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),

              // Indicador de Fase superior
              Text(
                isWorkPhase ? "TRABAJO" : "DESCANSO",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: isWorkPhase
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary,
                  letterSpacing: 4,
                ),
              ),

              // Temporizador Gigante en el centro
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  timeString,
                  style: TextStyle(
                    fontSize: 160, // Tamaño masivo para legibilidad a distancia
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFeatures: [
                      FontFeature.tabularFigures(),
                    ], // Evita que el texto salte al cambiar de número
                  ),
                ),
              ),

              // Contador de Sets y Controles inferiores
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      "Sets restantes: $setsRemaining",
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Botón de Acción Principal (inmenso)
                  SizedBox(
                    width: double.infinity,
                    height: 90,
                    child: ElevatedButton(
                      onPressed: () {
                        if (isRunning) {
                          timerNotifier.pauseTimer();
                        } else {
                          timerNotifier.startTimer();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isRunning
                            ? Theme.of(context)
                                  .colorScheme
                                  .surface // Fondo pausado
                            : Colors
                                  .white, // El blanco se ve bien en todos los temas
                        foregroundColor: isRunning
                            ? Colors.white
                            : Colors.black,
                      ),
                      child: Text(
                        isRunning ? "PAUSA" : "INICIAR",
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Barra de progreso mensual
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Desafío Mensual",
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${stats.routinesCompleted} / ${stats.targetRoutines}",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: (stats.routinesCompleted / stats.targetRoutines)
                            .clamp(0.0, 1.0), // Porcentaje de llenado
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        color: Theme.of(context).colorScheme.secondary,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
