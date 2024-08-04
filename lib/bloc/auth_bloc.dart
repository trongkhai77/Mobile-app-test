import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start/bloc/auth_event.dart';
import 'package:start/bloc/auth_state.dart';
import 'package:start/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<CheckLoginEvent>(_onCheckLogin);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final String response = await rootBundle.loadString('assets/users.json');
      final List<dynamic> data = jsonDecode(response);
      final List<User> users = data.map((json) => User.fromJson(json)).toList();

      final user = users.firstWhere(
        (user) => user.email == event.email && user.password == event.password,
        orElse: () => throw Exception("User not found"),
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      emit(AuthSuccess());
    } catch (error) {
      emit(AuthFailure('Incorrect email or password'));
    }
  }

  Future<void> _onCheckLogin(
      CheckLoginEvent event, Emitter<AuthState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      emit(AuthSuccess());
    } else {
      emit(AuthInitial());
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    emit(AuthInitial());
  }
}
