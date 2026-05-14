import 'dart:developer' as dev;

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void auth(String email, String password) async {
  final dio = Dio();
  final response = await dio.post(
    '${dotenv.get('API_URL')}/login',
    data: {'email': email, 'password': password},
  );
  dev.log('Trying to log with email: $email and password: $password');

  dev.log(response.statusCode.toString());
}

bool googleAuth() {
  return true;
}

bool appleAuth() {
  return true;
}
