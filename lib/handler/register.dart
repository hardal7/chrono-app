import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void register(String email, String username, String password) async {
  final dio = Dio();
  try {
    final response = await dio.post(
      '${dotenv.get('API_URL')}/register',
      data: {'email': email, 'username': username, 'password': password},
    );
  } on DioException catch (e) {
    print('Trying to log with email: $email and password: $password');
    if (e.response?.statusCode != 200) {
      print(e.error);
    }
  }
}
