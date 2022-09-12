import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nft_creation/auth/auth_bloc_bloc.dart';
import 'package:nft_creation/constants.dart';
import 'package:nft_creation/screens/nft_screen.dart';
import 'package:nft_creation/screens/settings_screen.dart';
import 'package:nft_creation/storage/firebase_connection.dart';

class GameScreen extends StatefulWidget {
  static const String id = 'game_screen';

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    final user =
        (context.watch<AuthBlocBloc>().state as AuthStateAuthenticated).user;
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 17.0),
            child: user.photoURL != null
                ? CircleAvatar(
                    backgroundImage: Image.network(user.photoURL!).image,
                  )
                : CircleAvatar(
                    radius: 15,
                    backgroundColor: kDefaultColor,
                    child: const Text("C"),
                  ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, SettingsScreen.id);
              },
            ),
          ]),
      backgroundColor: kDefaultBackgroundColor,
      // Slivers
      body: Container(
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Center(
              child: Text(
                "Your Selected NFT: ",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white60),
              ),
            ),
            FutureBuilder<String>(
              future: FirebaseConnection().getUrl(user),
              builder: (
                BuildContext context,
                AsyncSnapshot<String> snapshot,
              ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      Visibility(
                        visible: snapshot.hasData,
                        child: const Text("loading"),
                      ),
                    ],
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Text('Error');
                  } else if (snapshot.hasData) {
                    return Image.network(snapshot.data.toString());
                  } else {
                    return const Text('Empty data');
                  }
                } else {
                  return Text('State: ${snapshot.connectionState}');
                }
              },
            ),
            const SizedBox(height: 20),
            RawMaterialButton(
              fillColor: kDefaultColor,
              elevation: 0,
              padding: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onPressed: () => Navigator.pushNamed(context, NFTScreen.id),
              child: const Text(
                'Choose different NFT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
