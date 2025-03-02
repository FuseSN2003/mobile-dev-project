import 'package:classroom_app/blocs/classroom_detail/classroom_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Bottombar extends StatelessWidget {
  const Bottombar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      padding: EdgeInsets.zero,
      child: Container(
        // height: 100,
        width: double.infinity,
        // padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: BlocBuilder<ClassroomDetailBloc, ClassroomDetailState>(
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.description,
                        size: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        if (state is ClassroomDetailLoaded) {
                          Navigator.pushReplacementNamed(
                            context,
                            "/classroom_form",
                            arguments: state.classroom.id,
                          );
                        }
                      },
                    ),
                    Text(
                      "ฟอร์ม",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.work,
                        size: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        if (state is ClassroomDetailLoaded) {
                          Navigator.pushReplacementNamed(
                            context,
                            "/classroom_work",
                            arguments: state.classroom.id,
                          );
                        }
                      },
                    ),
                    Text(
                      "งานชั้นเรียน",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.home,
                        size: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        if (state is ClassroomDetailLoaded) {
                          Navigator.pushReplacementNamed(
                            context,
                            "/classroom_person",
                            arguments: state.classroom.id,
                          );
                        }
                      },
                    ),
                    Text(
                      "บุคคล",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
