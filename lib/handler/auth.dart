import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<int?> login(String name, String password) async {
  debugPrint('Sending login request');
  final dio = Dio(BaseOptions(validateStatus: (status) => status != null));
  final response = await dio.post(
    '${dotenv.get('API_URL')}/login',
    data: name.contains('@')
        ? {'email': name, 'password': password}
        : {'username': name, 'password': password},
  );
  debugPrint(response.statusCode.toString());
  return response.statusCode;
}

bool googleAuth() {
  return true;
}

bool appleAuth() {
  return true;
}
