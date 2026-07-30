import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../services/dio.dart';

Future<int?> getTopicTime(String name) async {
  try {
    debugPrint('Sending get topic time request');
    final response = await dio.get(
      '${dotenv.get('API_URL')}/topic/get',
      data: {'name': name},
    );
    debugPrint(response.statusCode.toString());
    return response.data['total_time_tracked_seconds'];
  } catch (e) {
    return null;
  }
}
