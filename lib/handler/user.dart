import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user.dart';
import '../services/dio.dart';

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

Future<List<LeaderboardUser>> getTopUsers(
  String scope, {
  String? matchName,
}) async {
  try {
    debugPrint('Sending get top users request');

    final response = await dio.get(
      '${dotenv.get('API_URL')}/user/top',
      data: {
        // TODO
        'cursor': 100000,
        'limit': 20,
        'scope': scope,
        'match_name': ?matchName,
      },
    );

    debugPrint(response.statusCode.toString());

    final users = List<Map<String, dynamic>>.from(response.data['users']);
    return users.map(LeaderboardUser.fromJson).toList();
  } catch (e) {
    return [];
  }
}

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

Future<void> setAccountPrivacy(bool hide) async {
  try {
    debugPrint('Sending set account privacy request');

    final response = await dio.post(
      '${dotenv.get('API_URL')}/user/privacy',
      data: {'hide': hide},
    );

    debugPrint(response.statusCode.toString());
  } catch (e) {
    debugPrint('Error sending set account privacy request: $e');
  }
}

Future<int?> uploadAvatar(XFile avatar) async {
  try {
    debugPrint('Sending upload avatar request');

    final bytes = await avatar.readAsBytes();

    final response = await dio.post(
      '${dotenv.get('API_URL')}/user/avatar',
      data: bytes,
      options: Options(contentType: 'image/jpeg'),
    );

    debugPrint(response.statusCode.toString());
    return response.statusCode;
  } catch (e) {
    debugPrint(e.toString());
    return null;
  }
}
