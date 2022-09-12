import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseConnection {
  Future<bool> uploadToStorage(Uint8List filePath, User user) async {
    // TODO: have a look @ this
    final fileName = 'NFTS/${user.email}/NFT.png';
    try {
      final ref = FirebaseStorage.instance.ref().child(fileName);
      var url = ref.putData(filePath);
      final snapshot = await url.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      CollectionReference nftList =
          FirebaseFirestore.instance.collection('nft_list');
      await nftList.doc(user.email).update({
        'url': downloadUrl,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<String> getUrl(User user) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('nft_list');
      final snapshot = await users.doc(user.email).get();
      final data = snapshot.data() as Map<String, dynamic>;
      return data['url'];
    } catch (e) {
      return 'Error fetching user';
    }
  }

  Future<String?> addUsername({
    required String email,
    required String userName,
  }) async {
    try {
      CollectionReference nftList =
          FirebaseFirestore.instance.collection('nft_list');

      // Call the user's CollectionReference to add a new user
      await nftList.doc(email).set({
        'User Name': userName,
        'url': "",
      });
      return 'success';
    } catch (e) {
      return 'Error adding user';
    }
  }

  Future<String?> updateUserName({
    required User user,
  }) async {
    try {
      CollectionReference nftList =
          FirebaseFirestore.instance.collection('nft_list');
      // Call the user's CollectionReference to add a new user
      await nftList.doc(user.email).update({
        'User Name': user.displayName,
      });
      return 'success';
    } catch (e) {
      return 'Error adding user';
    }
  }
}
