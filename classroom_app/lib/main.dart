import 'package:classroom_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:classroom_app/blocs/classroom_list_bloc/classroom_list_bloc.dart';
import 'package:classroom_app/core/constant.dart';
import 'package:classroom_app/screens/home_screen.dart';
import 'package:classroom_app/screens/login_screen.dart';
import 'package:classroom_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './theme/colors.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static void navigateToLogin() {
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  }

  static void navigateToHome() {
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => HomeScreen()),
      (route) => false,
    );
  }
}

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()..add(AppStarted())),
        BlocProvider(create: (context) => ClassroomListBloc()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          NavigationService.navigateToLogin();
        } else if (state is AuthAuthenticated) {
          NavigationService.navigateToHome();
        }
      },
      child: MaterialApp(
        title: AppConstant.appName,
        theme: darkMode,
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService.navigatorKey,
        home: const SplashScreen(),
      ),
    );
  }
}
