import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/model/usermodel/user_model.dart';

class dataRead{

  Stream<List<UserModal>> readUser() =>
      FirebaseFirestore.instance.collection('user').snapshots().map(
            (snapshot) => snapshot.docs
            .map((doc) => UserModal.fromJson(doc.data()))
            .toList(),
      );
}