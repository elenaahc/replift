import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_app/features/timer/presentation/widgets/settings_modal.dart';
import 'package:gym_app/features/timer/providers/timer_notifier.dart';

class TimerScreen extends ConsumerWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Más adelante reemplazaremos estos valores estáticos con ref.watch()
    // 1. Escuchamos el estado global de nuestro Provider
    final timerState = ref.watch(timerProvider);

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
                  color: isWorkPhase ? Colors.redAccent : Colors.greenAccent,
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
                      color: Colors
                          .grey[900], // Gris oscuro para hacer contraste con el fondo negro
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
                            ? Colors.grey[800]
                            : Colors.white,
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
