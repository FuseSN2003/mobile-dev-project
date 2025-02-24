import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../component/navbar.dart';
import '../component/createclassbar.dart';
import '../blocs/classroom/classroom_bloc.dart';
import '../blocs/classroom/classroom_state.dart';
import '../blocs/classroom/classroom_event.dart';
import '../component/sidebar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _isClassed = "Classed";
  @override
  void initState() {
    // print("This is MainPage");
    super.initState();
    debugPrint("Dispatching FetchStudent_Classrooms event...");
    BlocProvider.of<ClassroomBloc>(context).add(FetchStudent_Classrooms());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: NavBar(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
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
                        Navigator.pushNamed(context, '/assignment');
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
                              _isClassed = "Classed";
                            });
                          },
                          child: Text(
                            "Classed",
                            style: TextStyle(
                              fontSize: 16,
                              color:
                                  _isClassed == "Classed"
                                      ? Theme.of(context).colorScheme.onPrimary
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
                              _isClassed = "Created Classed";
                            });
                          },
                          child: Text(
                            "Created Classed",
                            style: TextStyle(
                              fontSize: 16,
                              color:
                                  _isClassed == "Created Classed"
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Colors.white54,
                              fontFamily: "Inder",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  BlocBuilder<ClassroomBloc, ClassroomState>(
                    builder: (context, ClassroomState) {
                      if (ClassroomState.classrooms.isEmpty) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        debugPrint("have classroom");
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          width: double.infinity,
                          child: ListView.builder(
                            itemCount: ClassroomState.classrooms.length,
                            itemBuilder: (context, index) {
                              final classroom =
                                  ClassroomState.classrooms[index];
                              debugPrint("Classroom : ${classroom.name}");
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
                                        "Teacher : ${classroom.teacher}",
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
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.menu_book,
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
                      }
                    },
                  ),
                ],
              ),
            ),
            CreateClassbar(),
          ],
        ),
      ),
    );
  }
}
