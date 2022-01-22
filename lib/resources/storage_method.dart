import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //add image to firebase storage.

  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    //ref : file의 포인터.
    //child : 폴더 계층구조.
    // => {root}/childName/userId
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);

    if (isPost) {
      String id = const Uuid().v1();
      ref.child(id);
      // => {root}/childName(=post)/userId/postId (sub collection is availabile);
    }

    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
