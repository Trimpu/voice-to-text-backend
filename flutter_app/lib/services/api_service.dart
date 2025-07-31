import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.getServerUrl(),
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
    ));

    // Add logging in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ));
    }
  }

  /// Transcribe audio file to text with optional translation
  Future<TranscriptionResult> transcribeAudio({
    required File audioFile,
    required String targetLanguage,
  }) async {
    try {
      // Create form data
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          audioFile.path,
          filename: audioFile.path.split('/').last,
        ),
        'lang': targetLanguage,
      });

      debugPrint('Sending request to: ${AppConfig.getServerUrl()}/transcribe');
      debugPrint('Target language: $targetLanguage');
      debugPrint('Audio file: ${audioFile.path}');

      final response = await _dio.post('/transcribe', data: formData);

      if (response.statusCode == 200) {
        final data = response.data;
        return TranscriptionResult(
          originalText: data['original_text'] ?? '',
          translatedText: data['translated_text'] ?? '',
          language: data['language'] ?? targetLanguage,
          status: data['status'] ?? 'success',
        );
      } else {
        throw ApiException('Server returned status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('DioException: ${e.message}');
      debugPrint('Response: ${e.response?.data}');
      
      if (e.type == DioExceptionType.connectionTimeout) {
        throw ApiException('Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw ApiException('Request timeout. The audio file might be too large.');
      } else if (e.response?.statusCode == 400) {
        final errorData = e.response?.data;
        throw ApiException(errorData['error'] ?? 'Bad request');
      } else if (e.response?.statusCode == 500) {
        final errorData = e.response?.data;
        throw ApiException(errorData['error'] ?? 'Server error occurred');
      } else {
        throw ApiException('Network error: ${e.message}');
      }
    } catch (e) {
      debugPrint('Unexpected error: $e');
      throw ApiException('Unexpected error: $e');
    }
  }

  /// Test server connection
  Future<bool> testConnection() async {
    try {
      final response = await _dio.get('/transcribe');
      // We expect a 405 Method Not Allowed for GET request
      return response.statusCode == 405;
    } catch (e) {
      debugPrint('Connection test failed: $e');
      return false;
    }
  }

  /// Update base URL for the API service
  void updateBaseUrl(String newBaseUrl) {
    _dio.options.baseUrl = newBaseUrl;
  }
}

class TranscriptionResult {
  final String originalText;
  final String translatedText;
  final String language;
  final String status;

  TranscriptionResult({
    required this.originalText,
    required this.translatedText,
    required this.language,
    required this.status,
  });

  @override
  String toString() {
    return 'TranscriptionResult(originalText: $originalText, translatedText: $translatedText, language: $language, status: $status)';
  }
}

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}