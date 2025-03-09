import 'package:classroom_app/blocs/classroom/classroom_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../component/createclassbar.dart';
import '../component/navbar.dart';
import '../component/sidebar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

enum ClassType { created, joined }

class _MainPageState extends State<MainPage> {
  ClassType _classType = ClassType.joined;

  @override
  void initState() {
    BlocProvider.of<ClassroomBloc>(context).add(FetchClassroomList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: NavBar(),
      bottomNavigationBar: CreateClassbar(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocListener<ClassroomBloc, ClassroomState>(
        listener: (context, state) {
          if (state is FetchClassroomListFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 1),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/thingtodo');
                        },
                        child: Text(
                          "Assignment",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 18,
                            fontFamily: 'KaushanScript',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                _classType = ClassType.joined;
                              });
                            },
                            child: Text(
                              "Classed",
                              style: TextStyle(
                                fontSize: 16,
                                color:
                                    _classType == ClassType.joined
                                        ? Theme.of(
                                          context,
                                        ).colorScheme.onPrimary
                                        : Colors.white54,
                                fontFamily: "Inder",
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                _classType = ClassType.created;
                              });
                            },
                            child: Text(
                              "Created Classed",
                              style: TextStyle(
                                fontSize: 16,
                                color:
                                    _classType == ClassType.created
                                        ? Theme.of(
                                          context,
                                        ).colorScheme.onPrimary
                                        : Colors.white54,
                                fontFamily: "Inder",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    BlocBuilder<ClassroomBloc, ClassroomState>(
                      builder: (context, state) {
                        if (state is ClassroomListLoaded) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            width: double.infinity,
                            child: ListView.builder(
                              itemCount:
                                  _classType == ClassType.joined
                                      ? state.studyingClassrooms.length
                                      : state.teachingClassrooms.length,
                              itemBuilder: (context, index) {
                                final classroom =
                                    _classType == ClassType.joined
                                        ? state.studyingClassrooms[index]
                                        : state.teachingClassrooms[index];
                                return Container(
                                  margin: EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    border: Border.all(
                                      // width: 2,
                                      // color: Colors.white54,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        "/classroom_form",
                                        arguments: classroom.id,
                                      );
                                    },
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Classroom :${classroom.name}",
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.onPrimary,
                                              fontSize: 12,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                          ),
                                        ),
                                        Text(
                                          "Teacher : ${classroom.createdBy}",
                                          style: TextStyle(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.onPrimary,
                                            fontSize: 12,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ],
                                    ),
                                    subtitle: Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Icon(
                                            Icons.import_contacts,
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                            size: 24,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else if (state is FetchClassroomListFailed) {
                          return Center(
                            child: Text(
                              state.errorMessage,
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
