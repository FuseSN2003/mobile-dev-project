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
      providers: [BlocProvider(create: (context) => ClassroomBloc())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: darkMode,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => MainPage(),
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
