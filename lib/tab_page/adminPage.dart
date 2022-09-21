import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/service/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class adminPage extends StatefulWidget {
  TabController tabController;

  adminPage(this.tabController);

  @override
  State<adminPage> createState() => _adminPageState();
}

class _adminPageState extends State<adminPage> {
  User? user;
  bool status = false;
  bool  check = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inputData();
  }

  inputData() async {
   String auth = FirebaseAuth.instance.currentUser!.uid;
    
    // user = auth.currentUser;
    if (user == null) {
      await user!.reload();
    }
    setState(() {
      status = true;
    });
    
    final firestore = FirebaseFirestore.instance.collection("user").doc(auth).snapshots();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      floatingActionButton: check ? FloatingActionButton(onPressed: () {
        widget.tabController.animateTo(1);
      },child: Text("Show Data")) : Text("user"),
      body: Column(
        children: [
          (status)
              ? ListTile(
                  title: Text("${user!.email}"),
                )
              : Center(child: CircularProgressIndicator()),


          ElevatedButton(onPressed: () async {
            await GoogleSignIn().signOut();
            widget.tabController.animateTo(0);
          }, child: Text("Logut"))
        ],
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
