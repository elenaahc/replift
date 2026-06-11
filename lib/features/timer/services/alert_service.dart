import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class AlertService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  AlertService() {
    _initAudioContext();
  }

  // Configuración crucial para que conviva con la música de fondo
  Future<void> _initAudioContext() async {
    await _audioPlayer.setAudioContext(
      AudioContextConfig(
        // Literalmente le decimos que NO haga ducking (bajar el volumen)
        duckAudio: false,
        // Opcional: respeta si tienes el teléfono muteado, pero sonará en audífonos
        respectSilence: false,
      ).build(),
    );
  }

  // Alerta corta para cambio de fase (Trabajo <-> Descanso)
  Future<void> playPhaseChangeAlert() async {
    // 1. Vibración: Dos pulsos cortos
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(pattern: [0, 200, 100, 200]);
    }

    // 2. Sonido (Asegúrate de tener el archivo en assets y pubspec.yaml)
    await _audioPlayer.play(AssetSource('beep_bajo.mp3'));
  }

  // Alerta larga para cuando terminas todos los sets
  Future<void> playRoutineCompletedAlert() async {
    // 1. Vibración: Una vibración larga e intensa
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 1000);
    }

    // 2. Sonido largo o repetido
    await _audioPlayer.play(
      AssetSource('final.mp3'),
    ); // Puedes cambiarlo por un sonido de "éxito"
  }
}
