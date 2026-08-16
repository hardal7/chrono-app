import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../services/dio.dart';

Future<int?> getTimeToday({String? topic}) async {
  try {
    debugPrint('Sending get topic time today request');

    final response = await dio.get(
      '${dotenv.get('API_URL')}/topic-event/today',
      data: {
        if (topic != null) 'topics': [topic],
      },
    );

    debugPrint(response.statusCode.toString());

    return response.data['total_time'];
  } catch (e) {
    return null;
  }
}
