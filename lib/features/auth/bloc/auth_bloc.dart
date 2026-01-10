import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groceryVault/features/grocery_list/data/grocery_list_store.dart';

import '../../../app/core/failure/failure.dart';
import '../../../app/di/injection.dart';
import '../../../sync/firestore_sync_service.dart';
import '../../grocery_list/sync/grocery_list_sync_adapter.dart';
import '../repository/auth_repository.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc(this._repository) : super(const AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthLoginRequested>(_onLogin);
    on<AuthGoogleLoginRequested>(_onGoogleLogin);
    on<AuthLogoutRequested>(_onLogout);
  }

  void _onAuthStarted(
      AuthStarted event,
      Emitter<AuthState> emit,
      ) async {
    final userOption = _repository.getSignedInUser();

    await userOption.match(
          () async {
        emit(const AuthUnauthenticated());
      },
          (user) async {
        await _startGrocerySync(user.uid);
        emit(const AuthAuthenticated());
      },
    );
  }

  Future<void> _onLogin(
      AuthLoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());

    final result = await _repository
        .signInWithEmail(
      email: event.email,
      password: event.password,
    )
        .run();

    if (emit.isDone) return;

    await result.match(
          (failure) async {
        emit(AuthFailureState(failure));
      },
          (_) async {
        final user = _repository.getSignedInUser().toNullable();
        if (user != null) {
          await _startGrocerySync(user.uid);
        }
        emit(const AuthAuthenticated());
      },
    );
  }

  Future<void> _onGoogleLogin(
      AuthGoogleLoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());

    final result = await _repository.signInWithGoogle().run();

    if (emit.isDone) return;

    await result.match(
          (failure) async {
        emit(AuthFailureState(failure));
      },
          (_) async {
        final user = _repository.getSignedInUser().toNullable();
        if (user != null) {
          await _startGrocerySync(user.uid);
        }
        emit(const AuthAuthenticated());
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

  Future<void> _startGrocerySync(String uid) async {
    final store = getIt<GroceryListStore>();
    final syncService = getIt<FirestoreSyncService>();

    final adapter = GroceryListSyncAdapter(store, uid);

    await syncService.syncNow(adapter);
    syncService.startRealtime(adapter);
  }
}
