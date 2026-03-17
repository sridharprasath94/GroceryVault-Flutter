import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/core/failure/failure.dart';
import '../repository/auth_repository.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc(this._repository) : super(AuthChecking()) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthLoginRequested>(_onLogin);
    on<AuthGoogleLoginRequested>(_onGoogleLogin);
    on<AuthLogoutRequested>(_onLogout);
  }

  void _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) async {
    final userOption = _repository.getSignedInUser();

    await userOption.match(
      () async {
        emit(const AuthUnauthenticated());
      },
      (user) async {
        emit(AuthAuthenticated(user.uid));
      },
    );
  }

  Future<void> _onLogin(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _repository
        .signInWithEmail(email: event.email, password: event.password)
        .run();

    if (emit.isDone) return;

    await result.match(
      (failure) async {
        emit(AuthFailureState(failure));
      },
      (_) async {
        final user = _repository.getSignedInUser().toNullable();
        if (user != null) {
          emit(AuthAuthenticated(user.uid));
        }
      },
    );
  }

  Future<void> _onGoogleLogin(
    AuthGoogleLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _repository.signInWithGoogle().run();

    if (emit.isDone) return;

    await result.match(
      (failure) async {
        emit(AuthFailureState(failure));
      },
      (_) async {
        final user = _repository.getSignedInUser().toNullable();
        if (user != null) {
          emit(AuthAuthenticated(user.uid));
        }
      },
    );
  }

  Future<void> _onLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _repository.signOut().run();

    if (emit.isDone) return;

    result.match(
      (failure) => emit(AuthFailureState(failure)),
      (_) => emit(const AuthUnauthenticated()),
    );
  }
}
