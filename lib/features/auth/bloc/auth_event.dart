part of 'auth_bloc.dart';

sealed class AuthEvent {}

class AuthStarted extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequested(this.email, this.password);
}

class AuthGoogleLoginRequested extends AuthEvent {}

class AuthLogoutRequested extends AuthEvent {}