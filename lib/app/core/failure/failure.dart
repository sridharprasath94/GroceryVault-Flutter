sealed class Failure {
  const Failure();
}

/// Auth-specific failures
sealed class AuthFailure extends Failure {
  const AuthFailure();
}

class InvalidCredentials extends AuthFailure {
  const InvalidCredentials();
}

class UserNotFound extends AuthFailure {
  const UserNotFound();
}

class NetworkFailure extends AuthFailure {
  const NetworkFailure();
}

class UnexpectedFailure extends AuthFailure {
  const UnexpectedFailure();
}

class CancelledByUser extends AuthFailure {
  const CancelledByUser();
}



sealed class GroceryFailure extends Failure {
  const GroceryFailure();
}

class GroceryNetworkFailure extends GroceryFailure {
  const GroceryNetworkFailure();
}

class GroceryCacheFailure extends GroceryFailure {
  const GroceryCacheFailure();
}

class GroceryUnexpectedFailure extends GroceryFailure {
  const GroceryUnexpectedFailure();
}