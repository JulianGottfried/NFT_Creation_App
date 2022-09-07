import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nft_creation/constants.dart';
import 'package:nft_creation/screens/login_screen.dart';
import 'package:nft_creation/screens/nft_screen.dart';
import 'package:nft_creation/screens/registration_screen.dart';
import 'package:flutter/material.dart';

import '../auth/auth_bloc_bloc.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBlocBloc, AuthBlocState>(
        listener: (context, state) {
          if (state is AuthStateAuthenticated) {
            Navigator.pushReplacementNamed(context, NFTScreen.id);
          }
        },
        child: Scaffold(
          backgroundColor: kDefaultBackgroundColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Icon(
                  Icons.token_outlined,
                  size: 120,
                  color: Colors.white,
                ),
                const Text(
                  'NFT Creation',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(
                  height: 80.0,
                ),
                RawMaterialButton(
                  fillColor: kDefaultColor,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                  child: const Text(
                    ' Log In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                RawMaterialButton(
                  fillColor: kDefaultColor,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, RegistrationScreen.id);
                  },
                  child: const Text(
                    "Register",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
