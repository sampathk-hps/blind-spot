sealed class Failure {
  const Failure(this.message);
  final String message;
}

final class StorageFailure extends Failure {
  const StorageFailure(super.message);
}

final class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

final class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

final class AiFailure extends Failure {
  const AiFailure(super.message);
}

final class EncryptionFailure extends Failure {
  const EncryptionFailure(super.message);
}

final class IapFailure extends Failure {
  const IapFailure(super.message);
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

final class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
