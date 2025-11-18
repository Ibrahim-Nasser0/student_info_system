
class TimeMeasure {
  static Future<T> measureAsync<T>(
    String label,
    Future<T> Function() action,
  ) async {
    final stopwatch = Stopwatch()..start();

    final result = await action();

    stopwatch.stop();
    print('$label took: ${stopwatch.elapsedMilliseconds} ms');

    return result;
  }
}
