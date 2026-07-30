import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../services/dio.dart';

Future<int?> login(String name, String password) async {
  try {
    debugPrint('Sending login request');
    final response = await dio.post(
      '${dotenv.get('API_URL')}/login',
      data: name.contains('@')
          ? {'email': name, 'password': password}
          : {'username': name, 'password': password},
    );
    debugPrint(response.statusCode.toString());
    return response.statusCode;
  } catch (e) {
    return null;
  }
}
