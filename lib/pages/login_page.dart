import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start/bloc/auth_bloc.dart';
import 'package:start/bloc/auth_state.dart';
import 'package:start/components/my_button.dart';
import 'package:start/components/my_textfield.dart';
import 'package:start/viewmodels/auth_view_model.dart';
import 'home_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // Text editing controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Validate Input
  bool _validateInputs(String email, String password) {
    final emailPattern = r'^[^@]+@[^@]+\.[^@]+';
    final passwordPattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$';

    final emailRegex = RegExp(emailPattern);
    final passwordRegex = RegExp(passwordPattern);

    return emailRegex.hasMatch(email) && passwordRegex.hasMatch(password);
  }

  // sign user in method
  void signUserIn(String email, String password, AuthViewModel authViewModel,
      BuildContext context) {
    if (_validateInputs(email, password)) {
      authViewModel.login(email, password);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password format')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = AuthViewModel(context.read<AuthBloc>());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 50),

                // logo
                const Icon(
                  Icons.lock,
                  size: 100,
                ),

                const SizedBox(height: 50),

                // welcome back, you've been missed
                Text(
                  'Welcome back, you\'ve been missed!',
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),

                const SizedBox(height: 50),

                // email textfield
                MyTextfield(
                  controller: _emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextfield(
                  controller: _passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),

                const SizedBox(height: 100),

                // sign in button
                MyButton(
                  // onTap: signUserIn,
                  onTap: () {
                    signUserIn(_emailController.text, _passwordController.text,
                        authViewModel, context);
                  },
                  text: 'Sign In',
                ),

                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const CircularProgressIndicator();
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
