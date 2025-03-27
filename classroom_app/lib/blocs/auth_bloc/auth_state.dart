part of 'auth_bloc.dart';

@immutable
sealed class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthChecking extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String token;
  final User user;

  AuthAuthenticated({required this.token, required this.user});
}

class AuthUnauthenticated extends AuthState {
  final String? message;

  AuthUnauthenticated({this.message});
}

class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {
  final String message;

  LoginSuccess({required this.message});
}

class LoginFailed extends AuthState {
  final String message;

  LoginFailed({required this.message});
}

class RegisterLoading extends AuthState {}

class RegisterSuccess extends AuthState {
  final String message;

  RegisterSuccess({required this.message});
}

class RegisterFailed extends AuthState {
  final String message;

  RegisterFailed({required this.message});
}
