import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../services/dio.dart';
import 'login.dart';

Future<int?> register(String email, String username, String password) async {
  try {
    debugPrint('Sending register request');

    final response = await dio.post(
      '${dotenv.get('API_URL')}/register',
      data: {'email': email, 'username': username, 'password': password},
    );

    debugPrint(response.statusCode.toString());

    login(username, password);
    return response.statusCode;
  } catch (e) {
    return null;
  }
}
