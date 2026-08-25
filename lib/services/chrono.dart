class ChronoService {
  ChronoService._();
  static final ChronoService instance = ChronoService._();

  final Stopwatch timer = Stopwatch();
  final Stopwatch stopwatch = Stopwatch();

  void timerStart() => timer.start();
  void timerStop() => timer.stop();
  void timerReset() => timer.reset();

  void stopwatchStart() => stopwatch.start();
  void stopwatchStop() => stopwatch.stop();
  void stopwatchReset() => stopwatch.reset();

  Duration get timerElapsed => timer.elapsed;
  Duration get stopwatchElapsed => stopwatch.elapsed;
}
