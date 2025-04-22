import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'member_event.dart';
part 'member_state.dart';

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  MemberBloc() : super(MemberInitial()) {
    on<FetchMembers>(_onFetchMembers);
  }

  void _onFetchMembers(FetchMembers event, Emitter<MemberState> emit) async {
    emit(MemberLoading());
    try {
      
    } catch (e) {
      emit(FetchMembersFailed(message: e.toString()));
    }
  }
}