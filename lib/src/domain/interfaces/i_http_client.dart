import 'dart:typed_data';

import '../api/response.dart';

abstract interface class IApiRequests {
  
  Future<ApiResponse<T?>> get<T>({
    required String endpoint,
    Map<String, String>? headers,
    Duration? timeout,
    T? Function(dynamic)? parser,
  });

  Future<ApiResponse<T?>> post<T>({
    required String endpoint,
    Map<String, String>? headers,
    Duration? timeout,
    Object? requestBody,
    T Function(dynamic)? parser,
  });

  Future<ApiResponse<T?>> postForm<T>({
    required String endpoint,
    Map<String, String>? headers,
    Duration? timeout,
    Uint8List? bytes,
    String? filename,
    T Function(dynamic)? parser,
    void Function(int, int)? onSendProgress,
  });

  Future<ApiResponse<T?>> put<T>({
    required String endpoint,
    Map<String, String>? headers,
    Duration? timeout,
    Object? requestBody,
    T Function(dynamic)? parser,
  });

  Future<ApiResponse<T?>> patch<T>({
    required String endpoint,
    Map<String, String>? headers,
    Duration? timeout,
    Object? requestBody,
    T Function(dynamic)? parser,
  });

  Future<ApiResponse<T?>> delete<T>({
    required String endpoint,
    Map<String, String>? headers,
    Duration? timeout,
    Object? requestBody,
    T Function(dynamic)? parser,
  });

  Future<ApiResponse<T?>> rawGet<T>(String endpoint, {
    Duration? timeout,
    T Function(dynamic)? parser
  });
  
}