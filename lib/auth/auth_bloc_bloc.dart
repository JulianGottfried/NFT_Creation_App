import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'auth_repository.dart';

part 'auth_bloc_event.dart';
part 'auth_bloc_state.dart';

class AuthBlocBloc extends Bloc<AuthBlocEvent, AuthBlocState> {
  AuthBlocBloc({required AuthRepository authRepository})
      : super(const AuthStateUnauthenticated()) {
    _authRepository = authRepository;

    _userSubscription =
        _authRepository.user.listen((user) => add(UserChanged(user: user)));

    on<UserChanged>(_userChanged);
  }

  late final AuthRepository _authRepository;

  late StreamSubscription<auth.User?>? _userSubscription;

  Future<void> _userChanged(UserChanged event, Emitter emit) async {
    event.user != null
        ? emit(AuthStateAuthenticated(user: event.user!))
        : emit(const AuthStateUnauthenticated());
  }

  Future<void> logIn({required String email, required String password}) async {
    await _authRepository.logIn(email: email, password: password);
  }

  Future<void> signUp(
      {required String email,
      required String password,
      required String userName}) async {
    await _authRepository.signUp(
        email: email, password: password, userName: userName);
  }

  Future<void> logOut() async {
    await _authRepository.logOut();
  }

  //Future<void> forgotPassword({required String email}) async {
  // await _authRepository.forgotPassword(email: email);
  //  }

  @override
  Future<void> close() async {
    await _userSubscription?.cancel();
    await super.close();
  }
}
