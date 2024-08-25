//CLASS TO CONTAIN EXCEPTION VALUE
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiException implements Exception {
  ApiException(
    this.message, {
    this.uri,
    this.code,
    this.isTimeout = false,
    this.isInternetActive = true,
  });

  final String message;
  final Uri? uri;
  final int? code;
  final bool? isTimeout;
  final bool? isInternetActive;

  @override
  String toString() {
    final b = StringBuffer()..write(message);

    return b.toString();
  }

  static Exception handleException(Exception e, String url) {
    if (e is DioException) {
      debugPrint("Dio Exception $url");
      if (e.type == DioExceptionType.badResponse) {
        if (e.response != null) {
          debugPrint("e.type == DioExceptionType.badResponse");
          return ApiException(
            e.response?.data["error"] ?? e.response?.data["message"],
            code: e.response!.statusCode,
            uri: Uri.parse(url),
          );
        } else {
          return ApiException(
            e.message ?? "",
            uri: Uri.parse(url),
          );
        }
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return ApiException(
          e.error.toString(),
          code: e.response!.statusCode,
          isTimeout: true,
          uri: Uri.parse(url),
        );
      } else if (e.message!.contains('host lookup')) {
        return ApiException(
          e.error.toString(),
          code: e.response!.statusCode,
          isInternetActive: false,
          uri: Uri.parse(url),
        );
      } else if (e.type == DioExceptionType.unknown) {
        return ApiException(
          e.error.toString(),
          code: e.response!.statusCode,
          isInternetActive: false,
          uri: Uri.parse(url),
        );
      }
      return ApiException(
        e.error.toString(),
        code: e.response!.statusCode,
        uri: Uri.parse(url),
      );
    }
    return e;
  }
}
