/// Custom exception thrown when a server-related error occurs.
class ServerException implements Exception {
  /// Optional message describing the server error.
  final String message;

  ServerException([this.message = '']);

  @override
  String toString() => message.isEmpty
      ? 'ServerException'
      : 'ServerException: ' + message;
}

/// Exception representing a cache failure.
class CacheException implements Exception {
  /// Optional message describing the cache issue.
  final String message;

  CacheException([this.message = '']);

  @override
  String toString() => message.isEmpty
      ? 'CacheException'
      : 'CacheException: ' + message;
}

/// Exception raised when validation fails.
class ValidationException implements Exception {
  /// Optional message describing the validation error.
  final String message;

  ValidationException([this.message = '']);

  @override
  String toString() => message.isEmpty
      ? 'ValidationException'
      : 'ValidationException: ' + message;
}
