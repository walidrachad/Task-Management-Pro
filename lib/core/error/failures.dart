/// Base class representing a failure in the application.
abstract class Failure {
  const Failure({this.message});

  /// Optional message describing the failure.
  final String? message;
}

/// Represents a failure that occurs when communicating with the server.
class ServerFailure extends Failure {
  const ServerFailure({super.message});
}

/// Represents a failure related to caching operations.
class CacheFailure extends Failure {
  const CacheFailure({super.message});
}

/// Represents a failure caused by invalid user input or validation logic.
class ValidationFailure extends Failure {
  const ValidationFailure({super.message});
}
