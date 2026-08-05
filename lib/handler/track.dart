import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../services/dio.dart';

void startTracker(Stopwatch stopwatch) {
  stopwatch.start();
}

Duration totalTime = Duration.zero;
void stopTracker(Stopwatch stopwatch) async {
  stopwatch.stop();
  Duration timeTracked = stopwatch.elapsed - totalTime;
  totalTime = stopwatch.elapsed;
  try {
    final response = await dio.post(
      '${dotenv.get('API_URL')}/topic-event/track',
      data: {
        'topic': 'General',
        'time_seconds': timeTracked.inSeconds,
        'date': DateTime.now().toUtc().toIso8601String(),
      },
    );
  } on DioException catch (e) {
    debugPrint('Trying to track time');
    if (e.response?.statusCode != 200) {
      debugPrint(e.error.toString());
    }
  }
}
