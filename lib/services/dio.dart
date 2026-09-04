import 'package:dio/dio.dart';
import 'package:dio_redirect_interceptor/dio_redirect_interceptor.dart';

final dio = Dio(
  BaseOptions(
    validateStatus: (status) => status != null,
    followRedirects: false,
  ),
);

Future<void> initDioIntercept() async {
  dio.interceptors.add(RedirectInterceptor(() => dio));
}
