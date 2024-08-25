import 'dart:core';
import 'dart:io';

import 'package:alice_dio/alice_dio_adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:alice/alice.dart';
import 'package:my_coffee_app_clone/core/error/exception.dart';
import 'package:my_coffee_app_clone/helpers/config.dart';
import 'package:my_coffee_app_clone/helpers/shared_pref.dart';

class ApiClient {
  static const int timeoutSecs = 30;
  static const int timeoutMs = timeoutSecs * 1000;
  final Dio dio;
  static ApiClient? _instance;
  String baseUrl = "";
  int clientId = 0;
  String appName = "";
  String userAgent = "";
  int organizationId = 0;

  Alice alice;

  factory ApiClient({required FlavorValues values}) {
    final BaseOptions options = BaseOptions(
      receiveTimeout: const Duration(milliseconds: 30000),
      connectTimeout: const Duration(milliseconds: 50000),
    );
    _instance ??= ApiClient._internal(
        Dio(options),
        values.baseUrl!,
        values.clientId!,
        values.appName!,
        values.userAgent!,
        values.alice!,
        values.organizationId!);
    return _instance!;
  }
  ApiClient._internal(
    this.dio,
    this.baseUrl,
    this.clientId,
    this.appName,
    this.userAgent,
    this.alice,
    this.organizationId,
  );
  static ApiClient get instance => _instance!;

  String? authorization;
  static void setAuth(String auth) {
    _instance!.authorization = auth;
    debugPrint('set Authorization ${_instance!.authorization}');
  }

  String? languageCode;
  static void setLanguageCode(String code) {
    _instance!.languageCode = code;
  }

  Future<Map<String, dynamic>> getHeaders() async {
    final userJWT = await getUserJWT();
    final userFirebaseId = await getFirebaseToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (userJWT.isNotEmpty) {
      headers.addAll({'Authorization': userJWT});
    }
    if (userFirebaseId!.isNotEmpty) {
      headers.addAll({'Device-Id': userFirebaseId});
    }

    return headers;
  }

  void initAliceInterceptor() {
    AliceDioAdapter aliceDioAdapter = AliceDioAdapter();
    alice.addAdapter(aliceDioAdapter);
    dio.interceptors.add(aliceDioAdapter);
  }

  Future<Response<Map<dynamic, dynamic>>> getData(
    String endpoint,
    String data, {
    Map<String, String>? headers,
    CancelToken? cancelToken,
  }) async {
    final String urlParam = endpoint + data;
    try {
      final response = await dio.get<Map>(
        urlParam,
        options: Options(headers: headers ?? await getHeaders()),
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw ApiException.handleException(e, urlParam);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<Map<dynamic, dynamic>>> postData(
    String endpoint, {
    required dynamic body,
    Map<String, dynamic>? headers,
  }) async {
    try {
      debugPrint("Body: $body");
      // dio.interceptors.add(alice.getDioInterceptor());
      final response = await dio.post<Map>(
        Uri.parse(endpoint).toString(),
        data: body,
        options: Options(
          headers: headers ?? await getHeaders(),
        ),
      );
      return response;
    } on DioException catch (e) {
      debugPrint("ERROR: $e");
      throw ApiException.handleException(e, endpoint);
    }
  }

  Future<Response<Map<dynamic, dynamic>>> delete(
    String endpoint, {
    required dynamic body,
    Map<String, dynamic>? headers,
  }) async {
    try {
      debugPrint("Body: $body");
      final response = await dio.delete<Map>(
        Uri.parse(endpoint).toString(),
        data: body,
        options: Options(
          headers: headers ?? await getHeaders(),
        ),
      );
      return response;
    } on DioException catch (e) {
      debugPrint("ERROR: $e");
      throw ApiException.handleException(e, endpoint);
    }
  }

  Future<Response<Map<dynamic, dynamic>>> patchData(
    String endpoint, {
    required dynamic body,
    Map<String, dynamic>? headers,
  }) async {
    try {
      // dio.interceptors.add(alice.getDioInterceptor());
      final response = await dio.patch<Map>(
        Uri.parse(endpoint).toString(),
        data: body,
        options: Options(
          headers: headers ?? await getHeaders(),
        ),
      );
      return response;
    } on DioException catch (e) {
      debugPrint("ERROR: $e");
      throw ApiException.handleException(e, endpoint);
    }
  }

  Future<Response<Map<dynamic, dynamic>>> postMultipartData(
    String endpoint,
    File file,
  ) async {
    final Map<String, dynamic> multipartHeaders = await getHeaders();
    multipartHeaders['Content-Type'] = 'multipart/form-data';
    // dio.interceptors.add(alice.getDioInterceptor());
    final Map<String, MultipartFile> multipartData = {
      'photo': await MultipartFile.fromFile(
        file.uri.path,
        filename: 'avatar.jpg',
      ),
    };
    final formData = FormData.fromMap(multipartData);

    return postData(endpoint, body: formData, headers: multipartHeaders);
  }

  Future<Response<Map<dynamic, dynamic>>> putData(
    String endpoint, {
    required dynamic data,
    Map<String, String>? headers,
  }) async {
    try {
      // dio.interceptors.add(alice.getDioInterceptor());
      final response = await dio.put<Map>(
        endpoint,
        data: data,
        options: Options(
          headers: headers ?? await getHeaders(),
        ),
      );
      return response;
    } on DioException catch (e) {
      throw ApiException.handleException(e, endpoint);
    }
  }

  Future<Response<Map<dynamic, dynamic>>> deleteData(
    String endpoint,
    String data, {
    Map<String, String>? headers,
  }) async {
    final String url = endpoint + data;
    try {
      // dio.interceptors.add(alice.getDioInterceptor());
      final response = await dio.delete<Map>(
        Uri.encodeFull(url),
        options: Options(headers: headers ?? await getHeaders()),
      );
      return response;
    } on DioException catch (e) {
      throw ApiException.handleException(e, url);
    }
  }

  Future<Response<dynamic>> unlinkData(
    String endpoint,
    String data, {
    Map<String, String>? headers,
  }) async {
    final String urlParam = endpoint;
    try {
      dio.options.method = "UNLINK";
      if (headers != null) {
        dio.options.headers = headers;
      }
      // dio.interceptors.add(alice.getDioInterceptor());
      final response = await dio.request(
        Uri.encodeFull(urlParam),
        data: data,
      );
      return response;
    } on DioException catch (e) {
      throw ApiException.handleException(e, urlParam);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<dynamic>> downloadData(
    String url, {
    Map<String, String>? headers,
    String? path,
  }) async {
    try {
      // dio.interceptors.add(alice.getDioInterceptor());
      final response = await dio.get(
        Uri.encodeFull(url),
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );
      debugPrint("Download Data Res: ${response.data}");
      return response;
    } on DioException catch (e) {
      debugPrint("downloadData error: $e");
      throw ApiException.handleException(e, url);
    }
  }
}
