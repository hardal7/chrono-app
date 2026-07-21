import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<int?> register(String email, String username, String password) async {
  debugPrint('Sending register request');
  final dio = Dio(BaseOptions(validateStatus: (status) => status != null));
  final response = await dio.post(
    '${dotenv.get('API_URL')}/register',
    data: {'email': email, 'username': username, 'password': password},
  );
  debugPrint(response.statusCode.toString());
  return response.statusCode;
}
