part of 'auth_bloc_bloc.dart';

@immutable
abstract class AuthBlocEvent {
  const AuthBlocEvent();
}

class UserChanged extends AuthBlocEvent {
  const UserChanged({required this.user});

  final auth.User? user;
}
