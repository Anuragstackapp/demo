import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../model/usermodel/user_model.dart';

logs(String messge){

  if(kDebugMode){
    print(messge);
  }
}


showMessage(BuildContext context,String message){

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

//firbase sore in data google
Future createUser(UserModal userModal) async {
  final firestore =
  FirebaseFirestore.instance.collection("user").doc("${userModal.uId}");

  await firestore.set(userModal.toJson());
}

Future createUsers(UserModal usermodel) async {
  final firestore =
  FirebaseFirestore.instance.collection("user").doc(usermodel.uId);

  final json = usermodel.toJson();

  await firestore.set(json);
}

deleteData(){

}