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
  try {
    final response = await dio.post(
      '${dotenv.get('API_URL')}/topic-event/track',
      data: {
        'topic': 'General',
        'time': timeTracked,
        'date': DateTime.now().toString(),
      },
    );
  } on DioException catch (e) {
    print('Trying to track time');
    if (e.response?.statusCode != 200) {
      print(e.error);
    }
  }
  totalTime = stopwatch.elapsed;
}
