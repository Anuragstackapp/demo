import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/model/usermodel/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/sherdprefrnce/sprfrnce.dart';

class adminPage extends StatefulWidget {
  TabController tabController;

  adminPage(this.tabController);

  @override
  State<adminPage> createState() => _adminPageState();
}

class _adminPageState extends State<adminPage> {
  User? user;
  bool status = false;
  bool check = false;
  String auth = FirebaseAuth.instance.currentUser!.uid;



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: () async {
          await GoogleSignIn().signOut();
          widget.tabController.animateTo(0);
          SherdPrefe.prefs = await SharedPreferences.getInstance();
          SherdPrefe.prefs!.clear();
        },child: Icon(Icons.logout)),

        body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection("user").doc(auth).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print("somthing wrong");
              return Center(child: Text("somthing wrong"));
            } else if (snapshot.hasData) {
              final user = snapshot.data!;
              UserModal userModal =
                  UserModal.fromJson(user.data() as Map<String, dynamic>);
              return ListView(
                children: [
                  ListTile(
                    title: Text("email :${userModal.email}"),
                    subtitle: Text("Type :${userModal.name}"),
                  ),
                  // Spacer(),
                  (userModal.name == "Admin") ? Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(onPressed: () async {
                      widget.tabController.animateTo(1);
                    }, child: Text("Show User Data")),
                  ) : Center(child: Text("User"),),

                ],
              );
            }else
              {
                return Center(child: CircularProgressIndicator(),);
              }
          },
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signOut();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
