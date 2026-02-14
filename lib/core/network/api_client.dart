import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'dart:developer' as developer;

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Intercepteur pour logger et gérer les erreurs
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          developer.log('🌐 ${options.method} ${options.uri}', name: 'ApiClient');
          developer.log('📤 Data: ${options.data}', name: 'ApiClient');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          developer.log('✅ ${response.statusCode} ${response.requestOptions.uri}', name: 'ApiClient');
          developer.log('📥 Response: ${response.data}', name: 'ApiClient');
          return handler.next(response);
        },
        onError: (error, handler) {
          developer.log('❌ Erreur API', name: 'ApiClient', error: error);
          
          // Extraire le message d'erreur du backend
          String errorMessage = 'Une erreur est survenue';
          
          if (error.response != null) {
            developer.log('📥 Error Response: ${error.response?.data}', name: 'ApiClient');
            
            final data = error.response?.data;
            if (data is Map<String, dynamic>) {
              // Essayer différents formats de message d'erreur
              errorMessage = data['message'] ?? 
                           data['error'] ?? 
                           data['msg'] ?? 
                           'Erreur ${error.response?.statusCode}';
            } else if (data is String) {
              errorMessage = data;
            }
          } else if (error.type == DioExceptionType.connectionTimeout) {
            errorMessage = 'Délai de connexion dépassé';
          } else if (error.type == DioExceptionType.receiveTimeout) {
            errorMessage = 'Délai de réception dépassé';
          } else if (error.type == DioExceptionType.connectionError) {
            errorMessage = 'Erreur de connexion au serveur';
          }
          
          // Créer une nouvelle erreur avec le message extrait
          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              response: error.response,
              type: error.type,
              error: errorMessage,
            ),
          );
        },
      ),
    );
  }

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw e.error ?? 'Erreur lors de la requête';
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw e.error ?? 'Erreur lors de la requête';
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } on DioException catch (e) {
      throw e.error ?? 'Erreur lors de la requête';
    }
  }

  Future<Response> patch(String path, {dynamic data}) async {
    try {
      return await _dio.patch(path, data: data);
    } on DioException catch (e) {
      throw e.error ?? 'Erreur lors de la requête';
    }
  }

  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } on DioException catch (e) {
      throw e.error ?? 'Erreur lors de la requête';
    }
  }
}
