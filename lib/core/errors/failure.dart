/// Base failure class for the application
abstract class Failure {
  final String message;

  const Failure({required this.message});

  @override
  String toString() => message;
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({required super.message});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}
