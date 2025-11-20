import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import 'storage_service.dart';

class ApiService {
  late Dio _dio;
  final StorageService _storageService;

  ApiService(this._storageService) {
    _initializeDio();
  }

  void _initializeDio() {
    // ✅ Obter URL e timeouts do StorageService
    final apiUrl = _storageService.getFullApiUrl();
    final connectionTimeout = _storageService.getConnectionTimeout();
    final receiveTimeout = _storageService.getReceiveTimeout();

    if (kDebugMode) {
      print('🌐 ApiService - Configurando:');
      print('   URL: $apiUrl');
      print('   Connection Timeout: ${connectionTimeout}s');
      print('   Receive Timeout: ${receiveTimeout}s');
    }

    _dio = Dio(
      BaseOptions(
        baseUrl: apiUrl,
        connectTimeout: Duration(seconds: connectionTimeout),
        receiveTimeout: Duration(seconds: receiveTimeout),
        headers: {
          'Content-Type': ApiConstants.contentType,
          'Accept': ApiConstants.accept,
        },
      ),
    );

    // Interceptor para token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storageService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await _storageService.clearAuth();
          }
          return handler.next(error);
        },
      ),
    );

    // Logging
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
  }

  /// ✅ Reconfigurar Dio com nova URL e timeouts (quando user muda nas settings)
  void reconfigure() {
    final newApiUrl = _storageService.getFullApiUrl();
    final newConnectionTimeout = _storageService.getConnectionTimeout();
    final newReceiveTimeout = _storageService.getReceiveTimeout();
    
    if (kDebugMode) {
      print('🔄 Reconfigurando ApiService:');
      print('   Nova URL: $newApiUrl');
      print('   Connection Timeout: ${newConnectionTimeout}s');
      print('   Receive Timeout: ${newReceiveTimeout}s');
    }

    _dio.options.baseUrl = newApiUrl;
    _dio.options.connectTimeout = Duration(seconds: newConnectionTimeout);
    _dio.options.receiveTimeout = Duration(seconds: newReceiveTimeout);
  }

  Dio get dio => _dio;

  // GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Tratamento de erros
  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Tempo de conexão esgotado. Tente novamente.');
      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);
      case DioExceptionType.cancel:
        return Exception('Requisição cancelada');
      default:
        return Exception('Erro de conexão. Verifique sua internet.');
    }
  }

  Exception _handleResponseError(Response? response) {
    if (response == null) {
      return Exception('Erro desconhecido');
    }

    final statusCode = response.statusCode;
    final data = response.data;

    String errorMessage = 'Erro no servidor';

    if (data is Map<String, dynamic>) {
      if (data.containsKey('errors') && data['errors'] is List) {
        final errors = data['errors'] as List;
        if (errors.isNotEmpty) {
          errorMessage = errors.join('\n');
        }
      } else if (data.containsKey('message')) {
        errorMessage = data['message'].toString();
      } else if (data.containsKey('title')) {
        errorMessage = data['title'].toString();
      }
    }

    switch (statusCode) {
      case 400:
        return Exception('Dados inválidos: $errorMessage');
      case 401:
        return Exception('Não autorizado. Faça login novamente.');
      case 403:
        return Exception('Acesso negado');
      case 404:
        return Exception('Recurso não encontrado');
      case 500:
        return Exception('Erro interno do servidor: $errorMessage');
      default:
        return Exception('Erro: $errorMessage');
    }
  }
}
