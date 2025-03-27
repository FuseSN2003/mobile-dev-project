part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  LoginRequested({required this.username, required this.password});
}

class RegisterRequested extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;

  RegisterRequested({
    required this.email,
    required this.password,
    required this.username,
    required this.confirmPassword,
  });
}

class LogoutRequested extends AuthEvent {}
