import 'package:go_router/go_router.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/auth/view/auth_screen.dart';
import '../../features/grocery_list/view/grocery_list_screen.dart';
import 'go_router_refresh_stream.dart';

class AppRouter {

  static GoRouter create(AuthBloc authBloc) {
    return GoRouter(
      initialLocation: '/auth',
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (context, state) {
        final authState = authBloc.state;

        final isLoggingIn = state.uri.path == '/auth';

        if (authState is AuthAuthenticated) {
          return isLoggingIn ? '/groceries' : null;
        }

        if (authState is AuthUnauthenticated ||
            authState is AuthInitial ||
            authState is AuthFailureState) {
          return isLoggingIn ? null : '/auth';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/auth',
          builder: (context, state) => const AuthScreen(),
        ),
        GoRoute(
          path: '/groceries',
          builder: (context, state) => const GroceryListScreen(),
        ),
      ],
    );
  }
}
