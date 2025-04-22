import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'classroom_detail_event.dart';
part 'classroom_detail_state.dart';

class ClassroomDetailBloc
    extends Bloc<ClassroomDetailEvent, ClassroomDetailState> {
  ClassroomDetailBloc() : super(ClassroomDetailInitial());
}
