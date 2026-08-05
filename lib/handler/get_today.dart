import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../services/dio.dart';

Future<int?> getTodayTime() async {
  try {
    debugPrint('Sending get topic time today request');
    final response = await dio.get(
      '${dotenv.get('API_URL')}/topic-event/today',
    );
    debugPrint(response.statusCode.toString());
    return response.data['total_time'];
  } catch (e) {
    return null;
  }
}
