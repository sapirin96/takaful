// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';

import '../../utils/catcher_util.dart';
import 'auth_service.dart';

class ApiService {
  static String baseUrl = 'https://portal.takafulcambodia.org/api/v1/';
  // static String baseUrl = 'http://sakal.test/api/v1/';
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiService.baseUrl,
      headers: {
        Headers.acceptHeader: Headers.jsonContentType,
        Headers.contentTypeHeader: Headers.jsonContentType,
      },
      connectTimeout: const Duration(minutes: 1),
      receiveTimeout: const Duration(minutes: 1),
    ),
  );

  static final __dio = _dio..interceptors.add(CustomInterceptors());

  static Future<dynamic> get(
    String url, {
    Map<String, dynamic>? params,
    Duration maxAge = const Duration(minutes: 15),
    Duration maxStale = const Duration(minutes: 15),
    bool forceRefresh = false,
  }) async {
    try {
      Response response = await __dio.get(
        url,
        queryParameters: params,
        // options: buildCacheOptions(maxAge, maxStale: maxStale, forceRefresh: forceRefresh),
      );

      if (response.data['success']) {
        return response.data['data'];
      } else {
        Get.rawSnackbar(message: response.data['data']);
      }
    } on DioException catch (error, stackTrace) {
      __handleError(error, stackTrace);
    }
  }

  static Future<dynamic> post(
    String url, {
    dynamic data,
    dynamic params,
  }) async {
    Response response;

    try {
      response = await __dio.post(url, data: data, queryParameters: params);

      if (response.data['success'] == true) {
        return response.data['data'];
      } else {
        Get.rawSnackbar(
          message: response.data['data'],
          backgroundColor: Colors.redAccent,
          margin: const EdgeInsets.all(8),
          borderRadius: 8,
          icon: const Icon(Icons.error_outline, color: Colors.white),
        );
      }
    } on DioException catch (error, stackTrace) {
      __handleError(error, stackTrace);
    }

    return null;
  }

  static Future<dynamic> put(
    String url, {
    dynamic data,
    dynamic params,
  }) async {
    Response? response;

    try {
      response = await __dio.put(url, data: data, queryParameters: params);
      if (response.data['success'] == true) {
        return response.data['data'];
      }
    } on DioException catch (error, stackTrace) {
      __handleError(error, stackTrace);
    }

    return response;
  }

  static Future<dynamic> delete(
    String url, {
    dynamic data,
    dynamic params,
  }) async {
    Response? response;

    try {
      response = await __dio.delete(url, data: data, queryParameters: params);

      if (response.data['success'] == true) {
        return response.data['data'];
      } else {
        Get.rawSnackbar(
          message: response.data['data'],
          backgroundColor: Colors.redAccent,
          margin: const EdgeInsets.all(8),
          borderRadius: 8,
          icon: const Icon(Icons.error_outline, color: Colors.white),
        );
        return null;
      }
    } on DioException catch (error, stackTrace) {
      __handleError(error, stackTrace);
    }

    return response;
  }

  static void __handleError(DioException error, StackTrace stackTrace) {
    switch (error.response?.statusCode) {
      case 422:
        Get.rawSnackbar(
          title: error.message,
          message: error.response?.data['message'],
        );
        break;
      case 400:
        Get.rawSnackbar(
          title: error.message,
          message: error.response?.statusMessage,
        );
        break;
      case 401:
        Get.rawSnackbar(
          title: error.message,
          message: error.response?.statusMessage,
        );
        break;
      case 404:
        Get.rawSnackbar(
          title: error.message,
          message: error.response?.statusMessage,
        );
        break;
      default:
        Get.rawSnackbar(
          title: error.message,
          message: error.response?.statusMessage,
        );
        CatcherUtil.report(error, stackTrace);
        break;
    }
  }
}

class CustomInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll({
      HttpHeaders.authorizationHeader: "Bearer ${Get.find<AuthService>().token.value}",
      // HttpHeaders.contentLanguageHeader:
      //     Get.find<SettingService>().defaultLocale.value,
    });

    print('REQUEST[${options.method}] => PATH: ${options.path} => PARAMS: ${options.queryParameters}');
    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler) async {
    print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      Get.rawSnackbar(
        title: '401',
        message: 'Unauthenticated',
        backgroundColor: Colors.redAccent,
      );
    }

    if (err.response?.statusCode == 404) {
      Get.rawSnackbar(
        title: err.response!.statusMessage ?? '404',
        message: err.message,
        backgroundColor: Colors.redAccent,
      );
    }

    if (err.type == DioExceptionType.connectionTimeout) {
      Get.rawSnackbar(
        title: 'Timeout'.tr,
        message: err.message,
        backgroundColor: Colors.redAccent,
      );
    }

    if (err.type == DioExceptionType.receiveTimeout) {
      Get.rawSnackbar(
        title: 'Timeout'.tr,
        message: err.message,
        backgroundColor: Colors.redAccent,
      );
    }

    return super.onError(err, handler);
  }
}
