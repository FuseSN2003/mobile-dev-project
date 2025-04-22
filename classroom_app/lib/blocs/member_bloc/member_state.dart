part of 'member_bloc.dart';

@immutable
sealed class MemberState {}

class MemberInitial extends MemberState {}

class MemberLoading extends MemberState {}

class MembersLoaded extends MemberState {}

class FetchMembersFailed extends MemberState {
  final String message;

  FetchMembersFailed({required this.message});
}
