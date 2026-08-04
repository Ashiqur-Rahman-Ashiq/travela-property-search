import 'package:dio/dio.dart';

class ApiErrorHandler {
  static String getMessage(dynamic error) {
    String errorDescription = "";
    if (error is Exception) {
      try {
        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.cancel:
              errorDescription = "Request to API server was cancelled";
              break;
            case DioExceptionType.connectionTimeout:
              errorDescription = "Connection timeout with API server";
              break;
            case DioExceptionType.sendTimeout:
              errorDescription = "Send timeout in connection with API server";
              break;
            case DioExceptionType.receiveTimeout:
              errorDescription = "Receive timeout in connection with API server";
              break;
            case DioExceptionType.badResponse:
              if (error.response?.data != null &&
                  error.response?.data is Map &&
                  error.response?.data['message'] != null) {
                errorDescription = error.response?.data['message'];
              } else {
                errorDescription = error.response?.statusMessage ?? "Server error occurred";
              }
              break;
            case DioExceptionType.connectionError:
              errorDescription = "No Internet Connection";
              break;
            default:
              errorDescription = "Unexpected error occurred";
              break;
          }
        } else {
          errorDescription = "Unexpected error occurred";
        }
      } catch (e) {
        errorDescription = e.toString();
      }
    } else {
      errorDescription = error.toString();
    }
    return errorDescription;
  }
}
