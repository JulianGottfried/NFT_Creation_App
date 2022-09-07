import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nft_creation/auth/auth_bloc_bloc.dart';
import 'package:nft_creation/auth/auth_repository.dart';
import 'package:nft_creation/screens/game_screen.dart';
import 'package:nft_creation/screens/login_screen.dart';
import 'package:nft_creation/screens/nft_screen.dart';
import 'package:nft_creation/screens/registration_screen.dart';
import 'package:nft_creation/screens/settings_screen.dart';
import 'package:nft_creation/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    BlocProvider<AuthBlocBloc>(
      create: (_) => AuthBlocBloc(
        authRepository: AuthRepository(),
      ),
      child: const NFTCreationApp(),
    ),
  );
}

class NFTCreationApp extends StatelessWidget {
  const NFTCreationApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        RegistrationScreen.id: (context) => const RegistrationScreen(),
        NFTScreen.id: (context) => const NFTScreen(),
        SettingsScreen.id: (context) => const SettingsScreen(),
        GameScreen.id: (context) => GameScreen(),
      },
    );
  }
}
