/// Result type for handling success and failure states
sealed class Result<T> {
  const Result();

  factory Result.success(T data) => Success(data);
  factory Result.failure(dynamic failure) => _FailureResult<T>(failure);

  R map<R>({
    required R Function(Success<T> success) onSuccess,
    required R Function(dynamic failure) onFailure,
  }) {
    if (this is Success<T>) {
      return onSuccess(this as Success<T>);
    } else if (this is _FailureResult) {
      return onFailure((this as _FailureResult).failure);
    }
    throw StateError('Unknown Result type');
  }

  V fold<V>({
    required V Function(T data) onSuccess,
    required V Function(dynamic failure) onFailure,
  }) {
    return map(
      onSuccess: (success) => onSuccess(success.data),
      onFailure: (failure) => onFailure(failure),
    );
  }
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class _FailureResult<T> extends Result<T> {
  final dynamic failure;
  const _FailureResult(this.failure);
}
