import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../services/dio.dart';

Future<void> setLocationPrivacy(bool hide) async {
  try {
    debugPrint('Sending set location privacy request');

    final response = await dio.post(
      '${dotenv.get('API_URL')}/location/privacy',
      data: {'hide': hide},
    );

    debugPrint(response.statusCode.toString());
  } catch (e) {
    debugPrint('Error sending set location privacy request: $e');
  }
}
