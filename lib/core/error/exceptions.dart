/// Base class for all application exceptions
abstract class AppException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  const AppException(this.message, [this.stackTrace]);

  @override
  String toString() => message;
}

/// Thrown when cache operations fail
class CacheException extends AppException {
  const CacheException(String message, [StackTrace? stackTrace])
      : super(message, stackTrace);
}

/// Thrown when network operations fail
class ServerException extends AppException {
  final int statusCode;
  final dynamic response;

  const ServerException({
    String message = 'Server error occurred',
    this.statusCode = 500,
    this.response,
    StackTrace? stackTrace,
  }) : super(message, stackTrace);

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

/// Thrown when network is not available
class NetworkException extends AppException {
  const NetworkException([String message = 'No internet connection'])
      : super(message);
}

/// Thrown when a requested resource is not found
class NotFoundException extends AppException {
  const NotFoundException([String message = 'Requested resource not found'])
      : super(message);
}

/// Thrown when user is not authenticated
class UnauthorizedException extends AppException {
  const UnauthorizedException([String message = 'Authentication required'])
      : super(message);
}

/// Thrown when user doesn't have permission to access a resource
class ForbiddenException extends AppException {
  const ForbiddenException([String message = 'Insufficient permissions'])
      : super(message);
}

/// Thrown when there's a validation error
class ValidationException extends AppException {
  final Map<String, List<String>> errors;

  const ValidationException(this.errors, [String message = 'Validation failed'])
      : super(message);

  @override
  String toString() => 'ValidationException: $message\nErrors: $errors';
}

/// Thrown when there's a timeout in network operations
class TimeoutException extends AppException {
  const TimeoutException([String message = 'Request timed out'])
      : super(message);
}

/// Thrown when an operation is not implemented
class UnimplementedException extends AppException {
  const UnimplementedException([String message = 'Not implemented yet'])
      : super(message);
}

/// Thrown when an unexpected error occurs
class UnexpectedException extends AppException {
  const UnexpectedException([String message = 'An unexpected error occurred'])
      : super(message);
}
