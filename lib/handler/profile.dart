import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/profile.dart';
import '../services/dio.dart';

Future<UserProfile?> getProfile(String username) async {
  try {
    debugPrint('Sending get profile request');

    final response = await dio.get(
      '${dotenv.get('API_URL')}/user/profile/$username',
    );

    debugPrint(response.statusCode.toString());
    return UserProfile.fromJson(response.data as Map<String, dynamic>);
  } catch (e) {
    return null;
  }
}
