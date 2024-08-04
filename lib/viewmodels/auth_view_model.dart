import 'package:start/bloc/auth_bloc.dart';
import 'package:start/bloc/auth_event.dart';

class AuthViewModel {
  final AuthBloc authBloc;

  AuthViewModel(this.authBloc);

  void login(String email, String password) {
    authBloc.add(
      LoginEvent(email, password),
    );
  }

  void checkLogin() {
    authBloc.add(
      CheckLoginEvent(),
    );
  }

  void logout() {
    authBloc.add(
      LogoutEvent(),
    );
  }
}
