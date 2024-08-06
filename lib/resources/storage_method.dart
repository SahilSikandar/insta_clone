import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class StoreMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<String> storeImage(
      String childName, Uint8List img, bool isPost) async {
    final userId = _auth.currentUser!.uid;
    Reference _reference = _storage.ref().child(childName).child(userId);

    if (isPost) {
      String id = Uuid().v1();
      _reference = _reference.child(id);
    }
    UploadTask _task = _reference.putData(img);
    TaskSnapshot _snap = await _task;
    String download = await _snap.ref.getDownloadURL();
    return download;
  }
}
