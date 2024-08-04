import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start/bloc/auth_bloc.dart';
import 'package:start/bloc/auth_event.dart';
import 'package:start/bloc/auth_state.dart';
import 'package:start/pages/home_page.dart';
import 'package:start/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => AuthBloc()..add(CheckLoginEvent()),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthSuccess) {
              return const MaterialApp(
                debugShowCheckedModeBanner: false,
                home: HomePage(),
              );
            } else {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: LoginPage(),
              );
            }
          },
        ),
      ),
    );
  }
}
