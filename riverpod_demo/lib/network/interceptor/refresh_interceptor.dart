import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_demo/network/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RefreshTokenInterceptor extends Interceptor {

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Refresh the user's authentication token.
      await refreshToken();
      // Retry the request.
      try {
        handler.resolve(await _retry(err.requestOptions));
      } on DioException catch (e) {
        debugPrint("retrying failed");
        // If the request fails again, pass the error to the next interceptor in the chain.
        handler.next(e);
      }

      debugPrint("======================================================================");
      debugPrint("TOKEN REFRESHED SUCCESSFULLY");
      debugPrint("======================================================================");
      // Return to prevent the next interceptor in the chain from being executed.
      return;
    }
    // Pass the error to the next interceptor in the chain.
    handler.next(err);
  }

  Future<void> refreshToken() async {
    var body = <String, String>{
      "refreshToken":
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc2VySUQiOiJjY2NiNmI4Zi00ZmQwLTQ5YWEtYTg0Mi1mMTMyNDgxNDNjNzMiLCJGaW5nZXJwcmludCI6WzI0NSwyMzEsOTUsMzYsNDIsNzQsMTE3LDE4NCwyMDEsMTcxLDE3LDcwLDE0MCwyNTMsMTk4LDIsMjI3LDExNCwxNywyMzIsMTQ3LDU5LDYyLDEzLDY3LDYyLDYwLDIzLDI0MiwyMzcsNDksODVdLCJleHAiOjE3MTk0MDcyNzksImlhdCI6MTcxNDIyMzI3OSwiaXNzIjoicGxhdGFibGVfY2xpZW50X3NlcnZlciJ9.NdwgI_ZxgGdaM4Nq4E7U10nDp716GvMnewgYUI-NFA0",
    };

    var r = await dio.post(
      "https://api-stage.platablenow.com/auth/refresh",
      data: body,
      options: Options(
        headers: {
          "Cookie": "__User-Fgp=bcd671e1-f37c-4567-8306-776f4af5d5c2; Path=/; Domain=platablenow.com; Secure; HttpOnly; Expires=Fri, 17 May 2024 13:07:59 GMT;"
        }
      )
    );

    var prefs = await SharedPreferences.getInstance();
    prefs.setString("token", r.data["accessToken"]);
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    // var prefs = await SharedPreferences.getInstance();

    final options = Options(
      method: requestOptions.method,
      contentType: requestOptions.contentType,
      // headers: {
      //   "Authorization": "Bearer ${prefs.getString("token") ?? ""}",
      // }
    );

    // Retry the request with the new `RequestOptions` object.
    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
