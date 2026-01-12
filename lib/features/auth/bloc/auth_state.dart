part of 'auth_bloc.dart';

sealed class AuthState {
  const AuthState();
}

class AuthLoading extends AuthState {}

class AuthChecking extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String uid;
  const AuthAuthenticated(this.uid);
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthFailureState extends AuthState {
  final AuthFailure failure;
  const AuthFailureState(this.failure);
}
