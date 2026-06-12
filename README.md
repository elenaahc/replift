# RepLift 🐍

RepLift es una aplicación de entrenamiento de intervalos diseñada para maximizar el rendimiento físico, con una identidad visual inspirada en la era *Reputation*. 

## 🛠 Características Técnicas

* **Arquitectura:** Desarrollado con Flutter utilizando **Riverpod** para la gestión de estados.
* **Persistencia:** Almacenamiento local mediante `shared_preferences`.
* **Personalización:** Sistema de temas dinámicos basado en "Eras" musicales (Reputation, Midnights, Butter, etc.).
* **Gamificación:** Meta mensual configurable de rutinas completadas.
* **Compatibilidad:** Optimizado para Android (ARM64).

## 🚀 Instalación en caso de que lo quieras editar tu mismo

1. Clona el repositorio.
2. Ejecuta `flutter pub get` para instalar las dependencias.
3. Asegúrate de tener configurado el entorno de Android.
4. Genera el APK de producción con:
```bash
   flutter build apk --release --split-per-abi