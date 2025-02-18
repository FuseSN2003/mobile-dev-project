// login_register_state.dart
abstract class LoginRegisterState {}

class LoginRegisterInitial extends LoginRegisterState {}

class LoginRegisterLoading extends LoginRegisterState {}

class LoginRegisterSuccess extends LoginRegisterState {
  final String message;

  LoginRegisterSuccess(this.message);
}

class LoginRegisterFailure extends LoginRegisterState {
  final String error;

  LoginRegisterFailure(this.error);
}
