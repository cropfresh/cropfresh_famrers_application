// * API SERVICE - NETWORK COMMUNICATION LAYER
// * Purpose: Handle all API communications with proper error handling and authentication
// ! SECURITY: Handles authentication tokens and sensitive data transmission

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/app_constants.dart';
import '../utils/logger.dart';
import 'storage_service.dart';

class ApiService {
  static ApiService? _instance;
  static ApiService get instance => _instance ??= ApiService._internal();
  
  late Dio _dio;
  final StorageService _storage = StorageService.instance;
  final AppLogger _logger = AppLogger.instance;
  
  ApiService._internal() {
    _initializeDio();
  }
  
  // * INITIALIZE DIO WITH INTERCEPTORS AND CONFIGURATION
  void _initializeDio() {
    _dio = Dio(BaseOptions(
      baseUrl: EnvironmentConfig.apiBaseUrl,
      connectTimeout: AppConstants.apiTimeout,
      receiveTimeout: AppConstants.apiTimeout,
      sendTimeout: AppConstants.apiTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    // Add interceptors
    _addInterceptors();
  }
  
  // * ADD NECESSARY INTERCEPTORS
  void _addInterceptors() {
    // Auth Interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: _onRequest,
      onResponse: _onResponse,
      onError: _onError,
    ));
    
    // Logging Interceptor (only in development)
    if (EnvironmentConfig.enableDetailedLogging) {
      _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ));
    }
  }
  
  // * REQUEST INTERCEPTOR - ADD AUTH TOKEN AND HEADERS
  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add auth token if available
    final token = await _storage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    // Add device info
    options.headers['User-Agent'] = await _getUserAgent();
    
    // Check connectivity
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw DioException(
        requestOptions: options,
        type: DioExceptionType.connectionError,
        message: 'No internet connection',
      );
    }
    
    _logger.info('API Request: ${options.method} ${options.path}');
    handler.next(options);
  }
  
  // * RESPONSE INTERCEPTOR - HANDLE SUCCESSFUL RESPONSES
  void _onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.info('API Response: ${response.statusCode} ${response.requestOptions.path}');
    handler.next(response);
  }
  
  // * ERROR INTERCEPTOR - HANDLE ERRORS AND TOKEN REFRESH
  Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    _logger.error('API Error: ${error.message}', error);
    
    // Handle 401 Unauthorized - Token refresh
    if (error.response?.statusCode == 401) {
      try {
        await _refreshToken();
        
        // Retry original request
        final options = error.requestOptions;
        final token = await _storage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
          final response = await _dio.fetch(options);
          handler.resolve(response);
          return;
        }
      } catch (e) {
        // Token refresh failed - logout user
        await _storage.clearAuthData();
        _logger.error('Token refresh failed', e);
      }
    }
    
    handler.next(error);
  }
  
  // * REFRESH AUTHENTICATION TOKEN
  Future<void> _refreshToken() async {
    final refreshToken = await _storage.getRefreshToken();
    if (refreshToken == null) throw Exception('No refresh token available');
    
    try {
      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
        options: Options(headers: {'Authorization': null}),
      );
      
      final newToken = response.data['access_token'];
      final newRefreshToken = response.data['refresh_token'];
      
      await _storage.saveToken(newToken);
      await _storage.saveRefreshToken(newRefreshToken);
      
      _logger.info('Token refreshed successfully');
    } catch (e) {
      _logger.error('Failed to refresh token', e);
      rethrow;
    }
  }
  
  // * GET USER AGENT STRING
  Future<String> _getUserAgent() async {
    final appName = AppConstants.appName;
    final appVersion = AppConstants.appVersion;
    final platform = Platform.operatingSystem;
    return '$appName/$appVersion ($platform)';
  }
  
  // * GENERIC GET REQUEST
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }
  
  // * GENERIC POST REQUEST
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }
  
  // * GENERIC PUT REQUEST
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }
  
  // * GENERIC DELETE REQUEST
  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }
  
  // * FILE UPLOAD WITH PROGRESS
  Future<ApiResponse<T>> uploadFile<T>(
    String path,
    File file, {
    String fieldName = 'file',
    Map<String, dynamic>? additionalData,
    ProgressCallback? onSendProgress,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
        if (additionalData != null) ...additionalData,
      });
      
      final response = await _dio.post(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );
      
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }
  
  // * HANDLE SUCCESSFUL RESPONSE
  ApiResponse<T> _handleResponse<T>(
    Response response,
    T Function(dynamic)? fromJson,
  ) {
    final data = response.data;
    
    if (fromJson != null && data != null) {
      try {
        final parsedData = fromJson(data['data'] ?? data);
        return ApiResponse.success(parsedData);
      } catch (e) {
        _logger.error('Failed to parse response data', e);
        return ApiResponse.error('Failed to parse response data');
      }
    }
    
    return ApiResponse.success(data as T?);
  }
  
  // * HANDLE API ERRORS
  ApiResponse<T> _handleError<T>(dynamic error) {
    String message = AppConstants.unknownError;
    int? statusCode;
    
    if (error is DioException) {
      statusCode = error.response?.statusCode;
      
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          message = 'Connection timeout. Please try again.';
          break;
        case DioExceptionType.connectionError:
          message = 'No internet connection. Please check your network.';
          break;
        case DioExceptionType.badResponse:
          message = _extractErrorMessage(error.response?.data) ?? 
                   'Server error occurred. Please try again.';
          break;
        case DioExceptionType.cancel:
          message = 'Request was cancelled.';
          break;
        default:
          message = 'Network error occurred. Please try again.';
      }
    }
    
    _logger.error('API Error: $message', error);
    return ApiResponse.error(message, statusCode: statusCode);
  }
  
  // * EXTRACT ERROR MESSAGE FROM RESPONSE
  String? _extractErrorMessage(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      return responseData['message'] ?? 
             responseData['error'] ?? 
             responseData['detail'];
    }
    return null;
  }
  
  // * DOWNLOAD FILE
  Future<ApiResponse<String>> downloadFile(
    String url,
    String savePath, {
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      await _dio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress,
      );
      
      return ApiResponse.success(savePath);
    } catch (e) {
      return _handleError<String>(e);
    }
  }
  
  // * CHECK CONNECTIVITY
  Future<bool> hasInternetConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      return false;
    }
  }
}

// * API RESPONSE WRAPPER CLASS
class ApiResponse<T> {
  final T? data;
  final String? error;
  final bool isSuccess;
  final int? statusCode;
  
  const ApiResponse._({
    this.data,
    this.error,
    required this.isSuccess,
    this.statusCode,
  });
  
  factory ApiResponse.success(T? data) {
    return ApiResponse._(
      data: data,
      isSuccess: true,
    );
  }
  
  factory ApiResponse.error(String error, {int? statusCode}) {
    return ApiResponse._(
      error: error,
      isSuccess: false,
      statusCode: statusCode,
    );
  }
  
  bool get isError => !isSuccess;
  
  // * FOLD PATTERN FOR HANDLING RESPONSE
  R fold<R>({
    required R Function(T? data) onSuccess,
    required R Function(String error) onError,
  }) {
    return isSuccess ? onSuccess(data) : onError(error ?? 'Unknown error');
  }
}

// * API ENDPOINTS CLASS
class ApiEndpoints {
  // * AUTH ENDPOINTS
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  
  // * FARMER ENDPOINTS
  static const String farmerProfile = '/farmer/profile';
  static const String farmerDashboard = '/farmer/dashboard';
  static const String farmerProducts = '/farmer/products';
  static const String farmerOrders = '/farmer/orders';
  static const String farmerLivestock = '/farmer/livestock';
  
  // * MARKETPLACE ENDPOINTS
  static const String marketplaceProducts = '/marketplace/products';
  static const String marketplaceCategories = '/marketplace/categories';
  static const String marketplaceSearch = '/marketplace/search';
  static const String marketplaceInquiries = '/marketplace/inquiries';
  static const String negotiations = '/negotiations';
  
  // * LOGISTICS ENDPOINTS
  static const String logisticsProviders = '/logistics/providers';
  static const String logisticsBookings = '/logistics/bookings';
  static const String logisticsTracking = '/logistics/tracking';
  
  // * INPUT ENDPOINTS
  static const String inputCategories = '/inputs/categories';
  static const String inputProducts = '/inputs/products';
  static const String inputOrders = '/inputs/orders';
  static const String inputDealers = '/dealers/nearby';
  
  // * VETERINARY ENDPOINTS
  static const String veterinarians = '/veterinarians/search';
  static const String vetAppointments = '/vet-appointments';
  static const String vetServices = '/vet-services';
  
  // * SOIL TESTING ENDPOINTS
  static const String soilLabs = '/soil-labs/search';
  static const String soilTests = '/soil-tests';
  static const String soilResults = '/soil-tests/results';
  
  // * KNOWLEDGE BASE ENDPOINTS
  static const String knowledgeCategories = '/knowledge/categories';
  static const String knowledgeContent = '/knowledge/content';
  static const String knowledgeSearch = '/knowledge/search';
  
  // * NURSERY ENDPOINTS
  static const String nurseries = '/nurseries/search';
  static const String plants = '/plants';
  static const String plantCatalog = '/plants/catalog';
  
  // * UTILITY ENDPOINTS
  static const String weather = '/weather';
  static const String marketPrices = '/market-prices';
  static const String locations = '/locations';
  static const String upload = '/upload';
  
  // * PRIVATE CONSTRUCTOR
  ApiEndpoints._();
} 