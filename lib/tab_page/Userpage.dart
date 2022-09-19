import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../service/user_model.dart';

class Userpage extends StatefulWidget {
  TabController tabController;
  Userpage(this.tabController);



  @override
  State<Userpage> createState() => _UserpageState();
}

class _UserpageState extends State<Userpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () async {
        await GoogleSignIn().signOut();
        print("Logut");
        widget.tabController.animateTo(0);
      },child: Icon(Icons.logout)),
      body: StreamBuilder<List<UserModal>>(
        stream: readUser(),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return Text('Somthing is wrong');
          }
          else if(snapshot.hasData){
            final user = snapshot.data!;

            return ListView(
              children: user.map(buildUser).toList(),
            );
          }
          else
            {
              return Center(child: CircularProgressIndicator(),);
            }
      },),
    );


  }

  Widget buildUser(UserModal userModal) => ListTile(
    title: Text(userModal.name!),
    subtitle: Text(userModal.email!),
    leading: Image.network("${userModal.userImage}"),
  );
  Stream<List<UserModal>> readUser() =>
      FirebaseFirestore.instance.collection('user').snapshots().map(
            (snapshot) => snapshot.docs.map((doc) => UserModal.fromJson(doc.data())).toList(),
      );

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
