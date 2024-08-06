import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String username;
  final String email;
  final String uid;
  final String photoUrl;
  final String bio;
  final List followers;
  final List following;
  final String password;
  UserModel({
    required this.username,
    required this.uid,
    required this.email,
    required this.photoUrl,
    required this.bio,
    required this.followers,
    required this.following,
    required this.password,
  });

  Map<String, dynamic> toMap() => {
        'username': username,
        'email': email,
        'uid': uid,
        'photoUrl': photoUrl,
        'bio': bio,
        'followers': followers,
        'following': following,
        'password': password,
      };

  static UserModel fromSnap(DocumentSnapshot documentSnapshot) {
    var snapshot = documentSnapshot.data() as Map<String, dynamic>;

    return UserModel(
      uid: snapshot['uid'],
      username: snapshot['username'],
      bio: snapshot['bio'],
      email: snapshot['email'],
      password: snapshot['password'],
      photoUrl: snapshot['photoUrl'],
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }

  // factory UserModel.fromMap(Map<String, dynamic> map) {
  //   return UserModel(
  //     username: map['username'] as String,
  //     email: map['email'] as String,
  //     photoUrl: map['photoUrl'] as String,
  //     bio: map['bio'] as String,
  //     followers: List.from((map['followers'] as List),
  //     following: List.from((map['following'] as List),
  //     password: map['password'] as String,
  //   );
}

  //String toJson() => json.encode(toMap());

  //factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);}
