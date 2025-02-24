import 'dart:convert';

import 'package:classroom_app/models/auth.dart';
import 'package:classroom_app/models/user.dart';
import 'package:classroom_app/utills/jwt_token.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
    on<Register>(_onRegister);
  }

  _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthChecking());
    await Future.delayed(Duration(seconds: 2));
    final token = await getToken();

    if (token == null) {
      return emit(UnAuthenticated());
    }

    try {
      final res = await http.get(
        Uri.parse('http://10.0.2.2:3000/auth/me'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final jsonData = authFromJSON(res.body);

      if (res.statusCode == 200) {
        return emit(Authenticated(token: token, user: jsonData.user!));
      } else {
        return emit(UnAuthenticated());
      }
    } catch (e) {
      debugPrint(e.toString());
      return emit(UnAuthenticated());
    }
  }

  _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final username = event.username;
    final password = event.password;

    try {
      final res = await http.post(
        Uri.parse('http://10.0.2.2:3000/auth/login'),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      final jsonData = authFromJSON(res.body);
      debugPrint(jsonData.token);

      if (res.statusCode == 200) {
        await saveToken(jsonData.token!);
        return emit(
          Authenticated(token: jsonData.token!, user: jsonData.user!),
        );
      } else {
        return emit(AuthError(message: jsonData.message));
      }
    } catch (e) {
      debugPrint(e.toString());
      return emit(AuthError(message: 'An error occurred'));
    }
  }

  _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await deleteToken();
    emit(UnAuthenticated());
  }

  _onRegister(Register event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final username = event.username;
    final email = event.email;
    final password = event.password;
    final confirmPassword = event.confirmPassword;

    try {
      final res = await http.post(
        Uri.parse('http://10.0.2.2:3000/auth/register'),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
        }),
      );
      final jsonData = authFromJSON(res.body);
      if (res.statusCode == 200) {
        await saveToken(jsonData.token!);
        return emit(
          Authenticated(token: jsonData.token!, user: jsonData.user!),
        );
      } else {
        return emit(AuthError(message: jsonData.message));
      }
    } catch (e) {
      debugPrint(e.toString());
      return emit(AuthError(message: 'An error occurred'));
    }
  }
}
