import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_demo/network/interceptor/refresh_interceptor.dart';
import 'package:riverpod_demo/network/interceptor/token_interceptor.dart';

final dio = Dio()
  ..options.headers["Content-Type"] = "application/json"
  ..options.headers['Access-Control-Allow-Origin'] = '*'
  ..interceptors.add(TokenInterceptor())
  ..interceptors.add(RefreshTokenInterceptor())
  ..interceptors.add(PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
    error: true,
  ));
