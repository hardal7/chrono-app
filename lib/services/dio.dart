import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

final dio = Dio(BaseOptions(validateStatus: (status) => status != null));

Future<void> initializeDio() async {
  final directory = await getApplicationDocumentsDirectory();

  final cookieJar = PersistCookieJar(
    ignoreExpires: true,
    storage: FileStorage(path.join(directory.path, 'cookies/')),
  );

  dio.interceptors.add(CookieManager(cookieJar));

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final cookies = await cookieJar.loadForRequest(options.uri);

        final authorizationCookie = cookies
            .where((cookie) => cookie.name == 'Authorization')
            .firstOrNull;

        if (authorizationCookie != null &&
            authorizationCookie.value.isNotEmpty) {
          options.headers['Authorization'] =
              'Bearer ${authorizationCookie.value}';
        }

        handler.next(options);
      },
    ),
  );
}
