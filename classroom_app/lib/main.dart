import 'package:flutter/material.dart';
import './screens/login_page.dart';
import './theme/colors.dart';
import './screens/register_page.dart';
import './screens/main_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      theme: DarkMode,
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/Login',
      routes: {
        '/Login': (context) => LoginPage(),
        '/Register': (context) => RegisterPage(),
        '/Main': (context) => MainPage(),
      },
    );
  }
}
