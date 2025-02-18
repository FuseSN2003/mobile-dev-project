// login_register_event.dart
abstract class LoginRegisterEvent {}

class LoginEvent extends LoginRegisterEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);
}

class RegisterEvent extends LoginRegisterEvent {
  final String email;
  final String password;

  RegisterEvent(this.email, this.password);
}
