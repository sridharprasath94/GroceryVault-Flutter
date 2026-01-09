import 'package:go_router/go_router.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/auth/view/auth_screen.dart';
import '../../features/grocery_list/view/grocery_list_screen.dart';
import 'go_router_refresh_stream.dart';

class AppRouter {
  static GoRouter create(AuthBloc authBloc) {
    var AuthLocation = '/auth';
    var groceriesListLocation = '/groceries_list';
    return GoRouter(
      initialLocation: AuthLocation,
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (context, state) {
        final authState = authBloc.state;

        final isLoggingIn = state.uri.path == AuthLocation;

        if (authState is AuthAuthenticated) {
          return isLoggingIn ? groceriesListLocation : null;
        }

        if (authState is AuthUnauthenticated ||
            authState is AuthInitial ||
            authState is AuthFailureState) {
          return isLoggingIn ? null : AuthLocation;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: AuthLocation,
          builder: (context, state) => const AuthScreen(),
        ),
        GoRoute(
          path: groceriesListLocation,
          builder: (context, state) => const GroceryListScreen(),
        ),
      ],
    );
  }
}
