import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadFile {
  void upload(File file, User user) async {
    final storageRef = FirebaseStorage.instance.ref();
    final ref = storageRef.child("${user.email}.png");

    try {
      await ref.putFile(file);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<String> loadFile(User user) async {
    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child('${user.email}.png');
    var url = await firebaseStorageRef.getDownloadURL();
    print(url);
    return url;
  }
}
