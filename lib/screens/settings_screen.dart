import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:nft_creation/auth/auth_bloc_bloc.dart';
import 'package:nft_creation/constants.dart';

class SettingsScreen extends StatefulWidget {
  static const String id = 'settings_screen';
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late DropzoneViewController controller1;

  late String username;

  @override
  Widget build(BuildContext context) {
    final user =
        (context.watch<AuthBlocBloc>().state as AuthStateAuthenticated).user;

    return Scaffold(
      backgroundColor: kDefaultBackgroundColor,
      appBar: AppBar(
        backgroundColor: kDefaultColor,
        title: const Text("SETTINGS"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "${user.displayName}",
                  hintStyle: const TextStyle(color: Colors.white),
                ),
                textAlign: TextAlign.center,
                onChanged: (value) {
                  username = value;
                },
              ),
            ),
            // user.photoURL == null -> Circle With the user initial (EX J for Julian or CG for Carlos Gutiérrez) if has photo -> Show photo

            // ++  being able to add / edit it
            TextButton(
              onPressed: () {
                try {
                  // find out how to upload images to firebase firestore and get the url back <-
                  // or use a picsum photo
                  //user.updatePhotoURL(photoURL)
                  user.updateDisplayName(username);
                } catch (e) {
                  print('ERROR: $e');
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: kDefaultColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                padding: const EdgeInsets.all(10),
                child: const Text(
                  "Change User Name",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
