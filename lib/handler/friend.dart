import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../services/dio.dart';

Future<int?> sendFriendRequest(String username) async {
  try {
    debugPrint('Sending friend request');

    final response = await dio.post(
      '${dotenv.get('API_URL')}/friend/create',
      data: {'username': username},
    );

    debugPrint(response.statusCode.toString());
    return response.statusCode;
  } catch (e) {
    debugPrint('Error sending friend request: $e');
    return null;
  }
}
