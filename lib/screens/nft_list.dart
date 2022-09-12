import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nft_creation/auth/auth_bloc_bloc.dart';
import 'package:nft_creation/constants.dart';
import 'package:nft_creation/screens/nft_screen.dart';
import 'package:nft_creation/screens/settings_screen.dart';

class NFTList extends StatefulWidget {
  static const String id = 'nft_list';

  const NFTList({super.key});

  @override
  State<NFTList> createState() => _NFTListState();
}

class _NFTListState extends State<NFTList> {
  final Stream<QuerySnapshot> streamList =
      FirebaseFirestore.instance.collection("nft_list").snapshots();

  @override
  Widget build(BuildContext context) {
    final user =
        (context.watch<AuthBlocBloc>().state as AuthStateAuthenticated).user;

    return Scaffold(
      backgroundColor: kDefaultBackgroundColor,
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
                  child: const Text(/*user.displayName![0]*/ "X"),
                ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, SettingsScreen.id);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 50),
          const Text(
            "Your selected NFT: ",
            style: TextStyle(
                color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 50),
          Center(
            child: StreamBuilder<QuerySnapshot>(
              stream: streamList,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text('Not data');
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      children: snapshot.data!.docs.map(
                        (DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          final String imageURL = data['url'];

                          return Card(
                            color: kDefaultBackgroundColor,
                            child: Column(
                              children: [
                                Image.network(
                                  imageURL,
                                  errorBuilder: (context, object, stackTrace) =>
                                      const Text('No bueno :('),
                                ),
                              ],
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  );
                }
              },
            ),
          ),
          const SizedBox(
            height: 30,
          ),
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
    );
  }
}
