import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../app/di/injection.dart';
import '../app/session/app_session_cubit.dart';
import '../features/auth/bloc/auth_bloc.dart';
import '../features/auth/repository/auth_repository.dart';
import 'router/app_router.dart';

class GroceryApp extends StatelessWidget {
  const GroceryApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();

    return MaterialApp.router(
      title: 'Grocery App',
      routerConfig: AppRouter.create(authBloc),
    );
  }
}

class AppBootstrap extends StatelessWidget {
  const AppBootstrap({super.key});

  @override
  Widget build(BuildContext context) {
    return bloc.MultiBlocProvider(
      providers: [
        bloc.BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            AuthRepository(
              FirebaseAuth.instance,
              webClientId: dotenv.env['GOOGLE_WEB_CLIENT_ID']!,
            ),
          )..add(AuthStarted()),
        ),
        bloc.BlocProvider<AppSessionCubit>(
          create: (_) => getIt<AppSessionCubit>(),
        ),
      ],
      child: bloc.BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          final sessionCubit = context.read<AppSessionCubit>();

          if (state is AuthAuthenticated) {
            await sessionCubit.onUserAuthenticated(state.uid);
          }

          if (state is AuthUnauthenticated) {
            await sessionCubit.onUserLoggedOut();
          }
        },
        child: const GroceryApp(),
      ),
    );
  }
}
