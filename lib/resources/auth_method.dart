import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone/resources/storage_method.dart';
import 'package:instagram_clone/model/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<model.UserModel> getUserDetails() async {
    User user = _auth.currentUser!;
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection("user").doc(user.uid).get();
    return model.UserModel.fromSnap(snap);
  }

  Future<String> signUp(
      {required String email,
      required String username,
      required String password,
      required Uint8List img,
      required String bio}) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          password.isNotEmpty ||
          img != null) {
        //create user
        final UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        //getStored profile
        final photoUrl =
            await StoreMethods().storeImage("profilePics", img, false);
        //user id to use
        final userId = cred.user!.uid;
        //store user to database

        //add user data
        model.UserModel user = model.UserModel(
            username: username,
            email: email,
            uid: userId,
            photoUrl: photoUrl,
            bio: bio,
            followers: [],
            following: [],
            password: password);
        await _firestore.collection("user").doc(userId).set(user.toMap());
        res = "success";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> signIn(
      {required String email, required String password}) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Fields are empty ";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
