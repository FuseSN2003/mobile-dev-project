part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {
  final String username;
  final String password;

  LoggedIn({required this.username, required this.password});
}

class LoggedOut extends AuthEvent {}

class Register extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;

  Register({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}
