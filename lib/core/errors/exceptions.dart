class ServerException implements Exception {
  final String message;
  final String? code;

  ServerException({this.message = 'Server error occurred', this.code});

  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {
  final String message;

  CacheException({this.message = 'Cache error occurred'});

  @override
  String toString() => 'CacheException: $message';
}

class NetworkException implements Exception {
  final String message;

  NetworkException({this.message = 'Network error occurred'});

  @override
  String toString() => 'NetworkException: $message';
}

class AuthException implements Exception {
  final String message;
  final String? code;

  AuthException({this.message = 'Authentication error', this.code});

  @override
  String toString() => 'AuthException: $message';
}

class ValidationException implements Exception {
  final String message;
  final Map<String, String>? fieldErrors;

  ValidationException({required this.message, this.fieldErrors});

  @override
  String toString() => 'ValidationException: $message';
}

class FileException implements Exception {
  final String message;

  FileException({required this.message});

  @override
  String toString() => 'FileException: $message';
}

class NotFoundException implements Exception {
  final String message;

  NotFoundException({this.message = 'Resource not found'});

  @override
  String toString() => 'NotFoundException: $message';
}
