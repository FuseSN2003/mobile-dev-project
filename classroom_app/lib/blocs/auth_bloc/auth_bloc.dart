import 'dart:convert';

import 'package:classroom_app/core/constant.dart';
import 'package:classroom_app/model/user_model.dart';
import 'package:classroom_app/utils/jwt_token.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthChecking());
    final token = await getToken();

    try {
      final response = await http.get(
        Uri.parse('${AppConstant.backendURL}/auth/me'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final jsonData = jsonDecode(response.body);

      if (jsonData['status'] == 'success') {
        final user = User.fromJson(jsonData['user']);
        final String currentToken = jsonData['token'];
        return emit(AuthAuthenticated(token: currentToken, user: user));
      } else {
        return emit(AuthUnauthenticated());
      }
    } catch (e) {
      debugPrint(e.toString());
      return emit(AuthUnauthenticated(message: "Something went wrong"));
    }
  }

  _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(LoginLoading());
    final username = event.username;
    final password = event.password;

    try {
      final response = await http.post(
        Uri.parse('${AppConstant.backendURL}/auth/login'),
        body: {'username': username, 'password': password},
      );

      final jsonData = jsonDecode(response.body);

      if (jsonData['status'] == 'success') {
        final user = User.fromJson(jsonData['user']);
        final String token = jsonData['token'];
        await saveToken(token);
        return emit(AuthAuthenticated(token: token, user: user));
      } else {
        return emit(LoginFailed(message: jsonData['message']));
      }
    } catch (e) {
      debugPrint(e.toString());
      return emit(LoginFailed(message: "Something went wrong"));
    }
  }

  _onRegisterRequested(RegisterRequested event, Emitter<AuthState> emit) async {
    emit(RegisterLoading());
    final username = event.username;
    final email = event.email;
    final password = event.password;
    final confirmPassword = event.confirmPassword;

    try {
      final response = await http.post(
        Uri.parse('${AppConstant.backendURL}/auth/register'),
        body: {
          'username': username,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
        },
      );

      final jsonData = jsonDecode(response.body);

      if (jsonData['status'] == 'success') {
        emit(RegisterSuccess(message: jsonData['message']));
        final user = User.fromJson(jsonData['user']);
        final String token = jsonData['token'];
        await saveToken(token);
        return emit(AuthAuthenticated(token: token, user: user));
      } else {
        return emit(RegisterFailed(message: jsonData['message']));
      }
    } catch (e) {
      debugPrint(e.toString());
      return emit(RegisterFailed(message: "Something went wrong"));
    }
  }

  _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    await removeToken();
    return emit(AuthUnauthenticated());
  }
}
