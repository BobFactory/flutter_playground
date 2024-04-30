import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void handleError(Object e, BuildContext context, {String customMessage = ""}) {
  if (e is DioException) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.badCertificate:
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("🛑 Error"),
            content: const Text(
                "You internet connection seems to be unstale. Please check your connection and try again."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              )
            ],
          ),
        );
        break;

      //Non 2xx response
      case DioExceptionType.badResponse:
        var title = "🛑 Error";
        var message = "";

        if (e.response?.data != null) {
          message = e.response?.data['error'] ?? "";
        }

        if (message.isEmpty && customMessage.isNotEmpty) {
          message = customMessage;
        }

        if (message.isEmpty) {
          message = 'Something went wrong, please try again later';
        }

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              )
            ],
          ),
        );

        break;

      case DioExceptionType.cancel:

        ///No need to handle this case.
        break;
    }
  } else {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("🛑 Error"),
        content: const Text("Something went wrong, please try again later"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }
}
