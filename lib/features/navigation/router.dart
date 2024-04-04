import 'package:finance_builder/features/account/accountDetailsScreen/account_details_screen.dart';
import 'package:finance_builder/features/account/createAccountScreen/create_account_screen.dart';
import 'package:finance_builder/features/auth/screens/sign_screen/SignScreen.dart';
import 'package:finance_builder/features/dashboard/dashboard.dart';
import 'package:finance_builder/features/splash/screens/SplashScreen.dart';
import 'package:finance_builder/main.dart';
import 'package:finance_builder/utils/constants.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  navigatorKey: navigatorKey,
  debugLogDiagnostics: true,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(
        title: '',
      ),
    ),
    GoRoute(
        path: '/sign', name: 'sign', builder: (context, state) => SignScreen()),
    GoRoute(
        path: '/',
        name: 'dashboard',
        builder: (context, state) => Dashboard(
              title: constants.screenNames.home,
            ),
        routes: [
          GoRoute(
            path: 'createAccountScreen',
            builder: (context, state) => CreateAccountScreen(
              title: constants.screenNames.createAccount,
            ),
          ),
          GoRoute(
            path: 'account/:id',
            name: 'account',
            builder: (context, state) => AccountDetailsScreen(
              id: state.pathParameters['id'],
            ),
          ),
        ]),
  ],
);
