import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nft_creation/auth/auth_bloc_bloc.dart';
import 'package:nft_creation/constants.dart';
import 'package:nft_creation/screens/settings_screen.dart';
import 'package:nft_creation/storage/upload_file.dart';

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
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: kDefaultColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                padding: const EdgeInsets.all(5),
                child: Text(
                  "${user.displayName}",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => context.read<AuthBlocBloc>().logOut(),
            ),
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
            const SizedBox(height: 30),
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
              future: UploadFile().loadFile(user),
              initialData:
                  'https://firebasestorage.googleapis.com/v0/b/nftcreation-27ecb.appspot.com/o/test@basf.com.png?alt=media&token=a58ba5a9-5aa1-47b4-8683-5ef6ccb2623f',
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
                        child: Image.network(snapshot.data!.toString()),
                      ),
                    ],
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Text('Error');
                  } else if (snapshot.hasData) {
                    return Image.network(snapshot.data!.toString());
                  } else {
                    return const Text('Empty data');
                  }
                } else {
                  return Text('State: ${snapshot.connectionState}');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
