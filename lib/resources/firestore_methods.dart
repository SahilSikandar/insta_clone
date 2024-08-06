import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone/resources/storage_method.dart';
import 'package:uuid/uuid.dart';

import '../model/post.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String photoUrl = await StoreMethods().storeImage('posts', file, true);
      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> storeLike(String uid, List likes, String postId) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection("posts").doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection("posts").doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> commentStore(String uid, String postId, String text,
      String profilePic, String name) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          "uid": uid,
          "likes": [],
          "commentId": commentId,
          "text": text,
          "name": name,
          "profile": profilePic,
          "publishedDate": DateTime.now()
        });
      } else {
        print("No comment Exist");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Future<void> commentLike(
  //     String uid, List likes, String postId, String commentId) async {
  //   try {
  //     if (likes.contains(uid)) {
  //       await _firestore
  //           .collection("posts")
  //           .doc(postId)
  //           .collection("comments")
  //           .doc(commentId)
  //           .update({
  //         'likes': FieldValue.arrayRemove([uid])
  //       });
  //     } else {
  //       await _firestore
  //           .collection("posts")
  //           .doc(postId)
  //           .collection("comments")
  //           .doc(commentId)
  //           .update({
  //         'likes': FieldValue.arrayUnion([uid])
  //       });
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  Future<void> commentLike(
      String uid, List likes, String postId, String commentId) async {
    try {
      if (likes.contains(uid)) {
        await _firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> delete(String postId) async {
    try {
      _firestore.collection("posts").doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> follow(String uid, String followId) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection("user").doc(uid).get();
      List following = (snapshot.data()! as dynamic)['following'];
      if (following.contains(followId)) {
        await _firestore.collection("user").doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
        await _firestore.collection("user").doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection("user").doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
        await _firestore.collection("user").doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
