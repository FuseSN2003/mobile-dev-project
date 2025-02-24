import 'package:classroom_app/blocs/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './screens/login_page.dart';
import './screens/main_page.dart';
import './screens/register_page.dart';
import './screens/assignment_page.dart';
import './screens/classroom_form_page.dart';
import './screens/classroom_work_page.dart';
import './screens/classroom_person_page.dart';
import './screens/classroom_addassignment.dart';
import './theme/colors.dart';

import 'blocs/classroom/classroom_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()..add(AppStarted())),
        BlocProvider(create: (context) => ClassroomBloc()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Classroom App',
      theme: darkMode,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => WithAuth(child: MainPage()),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/assignment': (context) => AssignmentPage(),
        '/classroom_form': (context) => ClassroomFormPage(),
        '/classroom_work': (context) => ClassroomWorkPage(),
        '/classroom_person': (context) => ClassroomPersonPage(),
        '/classroom_addassignment': (context) => AddAssignmentPage(),
      },
    );
  }
}

class WithAuth extends StatelessWidget {
  final Widget child;

  const WithAuth({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UnAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => false,
            );
          });
        }
      },
      builder: (context, state) {
        if (state is AuthChecking) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is UnAuthenticated) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return child;
        }
      },
    );
  }
}
