import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            AuthRepository(
              FirebaseAuth.instance,
              webClientId:
                  "462394198910-sr6icv7elk7t6ocqdgu1rpapj13mlccp.apps.googleusercontent.com",
            ),
          )..add(AuthStarted()),
        ),
      ],
      child: const GroceryApp(),
    );
  }
}
