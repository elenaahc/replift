import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/timer_notifier.dart';

class SettingsModal extends ConsumerStatefulWidget {
  const SettingsModal({super.key});

  @override
  ConsumerState<SettingsModal> createState() => _SettingsModalState();
}

class _SettingsModalState extends ConsumerState<SettingsModal> {
  late int _workTime;
  late int _restTime;
  late int _sets;

  @override
  void initState() {
    super.initState();
    final notifier = ref.read(timerProvider.notifier);
    _workTime = notifier.workTime;
    _restTime = notifier.restTime;
    _sets = notifier.initialSets;
  }

  // Interfaz de columnas tipo "Reloj" para ajustar minutos y segundos por separado
  Widget _buildTimeSelector(
    String title,
    int totalSeconds,
    Color accentColor,
    Function(int) onChanged,
  ) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;

    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: accentColor,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Control de Minutos (Suma/Resta de a 60 segundos)
            _buildColumnControl(
              value: minutes,
              onInc: () => onChanged(totalSeconds + 60),
              onDec: () => onChanged(
                totalSeconds >= 60 ? totalSeconds - 60 : totalSeconds % 60,
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                ":",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            // Control de Segundos (Suma/Resta de a 5 segundos)
            _buildColumnControl(
              value: seconds,
              onInc: () => onChanged(totalSeconds + 5),
              onDec: () => onChanged(
                totalSeconds >= 5 ? totalSeconds - 5 : totalSeconds,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget auxiliar para generar las flechas gigantes
  Widget _buildColumnControl({
    required int value,
    required VoidCallback onInc,
    required VoidCallback onDec,
  }) {
    return Column(
      children: [
        IconButton(
          onPressed: onInc,
          icon: const Icon(
            Icons.keyboard_arrow_up,
            size: 56,
            color: Colors.white70,
          ),
        ),
        Text(
          value.toString().padLeft(2, '0'),
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
        IconButton(
          onPressed: onDec,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 56,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  // El selector de sets se mantiene horizontal porque los números son pequeños
  Widget _buildSetsSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          const Text(
            "SERIES (SETS)",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => setState(() {
                  if (_sets > 1) _sets -= 1;
                }),
                icon: const Icon(
                  Icons.remove_circle_outline,
                  size: 48,
                  color: Colors.white54,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  _sets.toString(),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => setState(() => _sets += 1),
                icon: const Icon(
                  Icons.add_circle_outline,
                  size: 48,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 5),

            // Selectores apilados verticalmente para darles mucho espacio táctil
            _buildTimeSelector(
              "TIEMPO DE TRABAJO",
              _workTime,
              Colors.redAccent,
              (newVal) {
                setState(() => _workTime = newVal < 5 ? 5 : newVal);
              },
            ),

            const Divider(color: Colors.white12, height: 5, thickness: 1),

            _buildTimeSelector(
              "TIEMPO DE DESCANSO",
              _restTime,
              Colors.greenAccent,
              (newVal) {
                setState(() => _restTime = newVal < 5 ? 5 : newVal);
              },
            ),

            const Divider(color: Colors.white12, height: 5, thickness: 1),

            _buildSetsSelector(),

            const SizedBox(height: 5),

            // Botón Inmenso de Guardado
            SizedBox(
              width: double.infinity,
              height: 70,
              child: ElevatedButton(
                onPressed: () {
                  ref
                      .read(timerProvider.notifier)
                      .updateSettings(
                        work: _workTime,
                        rest: _restTime,
                        sets: _sets,
                      );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "GUARDAR RUTINA",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ), // Espaciado seguro para el gesto de inicio de iOS/Android
          ],
        ),
      ),
    );
  }
}
