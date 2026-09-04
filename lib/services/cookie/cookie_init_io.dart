import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../dio.dart';

Future<void> initCookieJar() async {
  debugPrint('Initializing cookie jar');
  final directory = await getApplicationDocumentsDirectory();

  final cookieJar = PersistCookieJar(
    ignoreExpires: true,
    storage: FileStorage(path.join(directory.path, 'cookies/')),
  );

  dio.interceptors.add(CookieManager(cookieJar));
}
