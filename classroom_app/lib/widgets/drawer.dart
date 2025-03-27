import 'package:classroom_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:classroom_app/blocs/classroom_list_bloc/classroom_list_bloc.dart';
import 'package:classroom_app/core/constant.dart';
import 'package:classroom_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatelessWidget {
  final bool isHomeScreen;

  const CustomDrawer({super.key, this.isHomeScreen = false});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppConstant.appName,
                  style: GoogleFonts.kaushanScript(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            Divider(color: Theme.of(context).colorScheme.secondary),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                spacing: 12,
                children: [
                  DrawerItem(
                    context: context,
                    title: 'หน้าแรก',
                    icon: Icons.home,
                    onTap:
                        isHomeScreen
                            ? null
                            : () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => const HomeScreen(),
                                ),
                                (route) => false,
                              );
                            },
                  ),
                  DrawerItem(
                    context: context,
                    title: 'สิ่งที่ต้องทำ',
                    icon: Icons.work,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            BlocBuilder<ClassroomListBloc, ClassroomListState>(
              builder: (context, state) {
                if (state is ClassroomListLoaded) {
                  final teachingClassrooms = state.teachingClassrooms;
                  final studyingClassrooms = state.studyingClassrooms;

                  return Column(
                    children: [
                      teachingClassrooms.isNotEmpty
                          ? Column(
                            children: [
                              Divider(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                child: Column(
                                  spacing: 12,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("ชั้นเรียนที่สอน"),
                                    ),
                                    ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      itemCount: teachingClassrooms.length,
                                      itemBuilder: (context, index) {
                                        final classroom =
                                            teachingClassrooms[index];
                                        return DrawerItem(
                                          context: context,
                                          title: classroom.name,
                                          subtitle: classroom.description,
                                          icon: Icons.class_,
                                          onTap: () {},
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                          : SizedBox(),
                      studyingClassrooms.isNotEmpty
                          ? Column(
                            children: [
                              Divider(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                child: Column(
                                  spacing: 12,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("ชั้นเรียนที่เรียน"),
                                    ),
                                    ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      itemCount: studyingClassrooms.length,
                                      itemBuilder: (context, index) {
                                        final classroom =
                                            studyingClassrooms[index];
                                        return DrawerItem(
                                          context: context,
                                          title: classroom.name,
                                          subtitle: classroom.description,
                                          icon: Icons.class_,
                                          onTap: () {},
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                          : SizedBox(),
                    ],
                  );
                } else if (state is ClassroomListLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is FetchClassroomListFailed) {
                  return Text(
                    state.message,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            Divider(color: Theme.of(context).colorScheme.secondary),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: DrawerItem(
                context: context,
                title: 'ออกจากระบบ',
                icon: Icons.logout,
                onTap: () {
                  context.read<AuthBloc>().add(LogoutRequested());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final BuildContext context;
  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback? onTap;

  const DrawerItem({
    super.key,
    required this.context,
    required this.title,
    this.subtitle,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.onSecondary,
      ),
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.roboto(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle:
            subtitle != null
                ? Text(
                  subtitle!,
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
                : null,
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        onTap: onTap,
      ),
    );
  }
}
