import 'package:classroom_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:classroom_app/blocs/classroom_list_bloc/classroom_list_bloc.dart';
import 'package:classroom_app/widgets/appbar.dart';
import 'package:classroom_app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ClassroomListBloc>().add(FetchClassroomList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(isHomeScreen: true),
      drawer: CustomDrawer(),
      body: Center(
        child: Column(
          children: [
            const Text('Welcome to Home Screen'),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(LogoutRequested());
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
