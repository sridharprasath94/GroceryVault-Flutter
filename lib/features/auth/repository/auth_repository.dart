import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fpdart/fpdart.dart';

import '../../../app/core/failure/failure.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository(
      this._auth, {
        required String webClientId,
      }) : _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: webClientId,
  );

  TaskEither<AuthFailure, Unit> signInWithEmail({
    required String email,
    required String password,
  }) {
    return TaskEither.tryCatch(
      () async {
        final result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (result.user == null) {
          throw const UnexpectedFailure();
        }

        return unit;
      },
      (error, _) => _mapFirebaseError(error),
    );
  }

  TaskEither<AuthFailure, Unit> signInWithGoogle() {
    return TaskEither.tryCatch(
      () async {
        // 🔥 Force account chooser by clearing cached Google session
        try {
          await _googleSignIn.signOut();
          await _googleSignIn.disconnect();
        } catch (_) {
          // Ignore – disconnect can throw if no prior session exists
        }

        // 1️⃣ Trigger Google account chooser
        final googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          throw const CancelledByUser();
        }

        // 2️⃣ Retrieve authentication tokens
        final googleAuth = await googleUser.authentication;
        final idToken = googleAuth.idToken;
        final accessToken = googleAuth.accessToken;

        if (idToken == null || accessToken == null) {
          throw const UnexpectedFailure();
        }

        // 3️⃣ Create Firebase credential
        final credential = GoogleAuthProvider.credential(
          idToken: idToken,
          accessToken: accessToken,
        );

        // 4️⃣ Sign in to Firebase
        final result = await _auth.signInWithCredential(credential);
        if (result.user == null) {
          throw const UnexpectedFailure();
        }

        return unit;
      },
      (error, s) {
        print('Sridhar Google sign-in error: $error');
        if (error is AuthFailure) return error;
        if (error is FirebaseAuthException) {
          return _mapFirebaseError(error);
        }
        return const UnexpectedFailure();
      },
    );
  }

  TaskEither<AuthFailure, Unit> signOut() {
    return TaskEither.tryCatch(
      () async {
        await _googleSignIn.signOut();
        await _auth.signOut();
        return unit;
      },
      (_, __) => const UnexpectedFailure(),
    );
  }

  AuthFailure _mapFirebaseError(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return const UserNotFound();
        case 'wrong-password':
          return const InvalidCredentials();
        case 'network-request-failed':
          return const NetworkFailure();
      }
    }
    return const UnexpectedFailure();
  }

  Option<User> getSignedInUser() {
    return Option.fromNullable(_auth.currentUser);
  }
}