class TimerState {
  final int timeRemaining;
  final bool isWorkPhase;
  final int setsRemaining;
  final bool isRunning;

  TimerState({
    required this.timeRemaining,
    required this.isWorkPhase,
    required this.setsRemaining,
    this.isRunning = false,
  });

  TimerState copyWith({
    int? timeRemaining,
    bool? isWorkPhase,
    int? setsRemaining,
    bool? isRunning,
  }) {
    return TimerState(
      timeRemaining: timeRemaining ?? this.timeRemaining,
      isWorkPhase: isWorkPhase ?? this.isWorkPhase,
      setsRemaining: setsRemaining ?? this.setsRemaining,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}
