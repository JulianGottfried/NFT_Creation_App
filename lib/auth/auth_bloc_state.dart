part of 'auth_bloc_bloc.dart';

@immutable
abstract class AuthBlocState {
  const AuthBlocState();
}

class AuthStateUnauthenticated extends AuthBlocState {
  const AuthStateUnauthenticated();
}

class AuthStateAuthenticated extends AuthBlocState {
  const AuthStateAuthenticated({required this.user});
  final auth.User user;
}
