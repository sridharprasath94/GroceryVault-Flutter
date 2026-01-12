import 'package:go_router/go_router.dart';
import 'package:groceryVault/features/splash/splash_screen.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/auth/view/auth_screen.dart';
import '../../features/grocery_list/view/grocery_list_screen.dart';
import 'go_router_refresh_stream.dart';

class AppRouter {
  static GoRouter create(AuthBloc authBloc) {
    var authLocation = '/auth';
    var groceriesListLocation = '/groceries_list';
    var splashLocation = '/splash';
    return GoRouter(
      initialLocation: splashLocation,
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (context, state) {
        final authState = authBloc.state;
        final location = state.uri.path;

        if (authState is AuthChecking) {
          return location == splashLocation ? null : splashLocation;
        }

        // Logged in → go to groceries
        if (authState is AuthAuthenticated) {
          return location == groceriesListLocation
              ? null
              : groceriesListLocation;
        }

        // Logged out → go to auth
        if (authState is AuthUnauthenticated) {
          return location == authLocation ? null : authLocation;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: splashLocation,
          builder: (context, state) {
            return const SplashScreen();
          },
        ),
        GoRoute(
          path: authLocation,
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
