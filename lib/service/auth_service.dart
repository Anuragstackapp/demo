import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/model/dataread/dataRead.dart';
import 'package:demo/service/sharedpreferences_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/material/tab_controller.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../common/method/methods.dart';
import '../model/usermodel/user_model.dart';

class AuthService{
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<UserCredential?> createUser(String email,String password, TabController tabController, String character, BuildContext context) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(credential);
      tabController.animateTo(2);


      setPrefKey("login", "yes");
      UserModal usermodel = UserModal(
        email: email,
        password: password,
        uId: credential.user!.uid,
        type: character,
      );
      createUsers(usermodel);
      logs('User Data --> ${credential.user}');


    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        logs('email-already-in-use${e.message}');

        verifyUser(context, email, password, tabController, character);
      }
    } catch (e) {
      print(e);

    }

  }

  verifyUser(BuildContext context,String email,String password, TabController tabController, String character,) async {
    try {
      final UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: email, password: password);

      final DocumentReference check = FirebaseFirestore.instance.collection("user").doc(credential.user!.uid);
      final data = FirebaseFirestore.instance.collection("user").snapshots();

      QuerySnapshot users = await FirebaseFirestore.instance.collection('users').get();
      List<UserModal> userModelList = <UserModal>[];
      for (QueryDocumentSnapshot element in users.docs) {
        UserModal userModal = UserModal.fromJson(element.data() as Map<String, dynamic>);
        userModelList.add(userModal);
      }
      UserModal currentUSerModel = userModelList.firstWhere((element) => element.uId == credential.user!.uid,
          orElse: () => UserModal());
      if(currentUSerModel.uId!.isEmpty) {

      }

      UserModal usermodel = UserModal(
              email: email,
              password: password,
              uId: credential.user!.uid,
              type: character,
            );

            if(check.id != credential.user!.uid){
              createUsers(usermodel);
            }


            setPrefKey("login", "yes");

            tabController.animateTo(2);
            print(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');

        String message =
            "Wrong password provided for that user.";

        showMessage(context, message);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(errorD),
        //     action: SnackBarAction(
        //       label: 'Action',
        //       onPressed: () {},
        //     ),
        //   ),
        // );
      }
    }
  }

}