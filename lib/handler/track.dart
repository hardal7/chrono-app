import 'dart:developer' as dev;

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void startTracker(Stopwatch stopwatch, Duration totalTime) {
  stopwatch.start();
}

void stopTracker(Stopwatch stopwatch, Duration totalTime) async {
  stopwatch.stop();
  int timeTracked = stopwatch.elapsed.compareTo(totalTime);
  final dio = Dio();
  // Make PUT request to event tracker endpoint
  final response = await dio.get('${dotenv.get('API_URL')}/health');
  dev.log(response.toString());
  totalTime = stopwatch.elapsed;
}
