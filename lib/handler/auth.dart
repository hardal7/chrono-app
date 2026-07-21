import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void login(String email, String password) async {
  final dio = Dio();
  try {
    final response = await dio.post(
      '${dotenv.get('API_URL')}/login',
      data: {'username': email, 'password': password},
    );
    log(response.toString());
  } on DioException catch (e) {
    log('Trying to log with email: $email and password: $password');
    if (e.response?.statusCode != 200) {
      log(e.error.toString());
    }
  }
}

bool googleAuth() {
  return true;
}

bool appleAuth() {
  return true;
}
