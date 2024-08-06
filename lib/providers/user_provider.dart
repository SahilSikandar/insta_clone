//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone/model/user.dart';
import 'package:instagram_clone/resources/auth_method.dart';
import 'package:provider/provider.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final AuthMethods _authMethods = AuthMethods();
  UserModel get getUser => _user!;

  Future<void> refreshUser() async {
    UserModel userData = await _authMethods.getUserDetails();
    _user = userData;
    notifyListeners();
  }
}
