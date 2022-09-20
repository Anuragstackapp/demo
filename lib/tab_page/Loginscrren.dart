import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/home_page/restepassword.dart';
import 'package:demo/service/sprfrnce.dart';

// import 'package:demo/Firstpage/Demo.dart';
import 'package:demo/service/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginscrren extends StatefulWidget {
  TabController tabController;

  Loginscrren(this.tabController);

  @override
  State<Loginscrren> createState() => _LoginscrrenState();
}

class _LoginscrrenState extends State<Loginscrren> {
  TextEditingController temail = TextEditingController();
  TextEditingController tpassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: temail,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'email',
                    hintText: 'Enter Your email',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: tpassword,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'password',
                    hintText: 'Enter Your password',
                  ),
                ),
              ),
              TextButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return restPassword();
                },));
              }, child: Text("forgot password")),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: temail.text,
                          password: tpassword.text
                      );
                      print(credential);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                      }
                    }
                  },
                  child: const Text("Login")),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      final credential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: temail.text,
                        password: tpassword.text,
                      );
                      print(credential);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        print('The password provided is too weak.');
                      } else if (e.code == 'email-already-in-use') {
                        print('The account already exists for that email.');
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: const Text("Submit")),

              ElevatedButton(
                  onPressed: () async {
                    UserCredential? login = await signInWithGoogle();

                    if (login.user != null) {
                      UserModal userModal = UserModal(
                        email: login.user!.email,
                        name: login.user!.displayName,
                        phone: login.user!.phoneNumber,
                        uId: login.user!.uid,
                        userImage: login.user!.photoURL,
                      );
                      createUser(userModal);
                      widget.tabController.animateTo(1);
                      SherdPrefe.prefs = await SharedPreferences.getInstance();
                      await SherdPrefe.prefs!.setString("login", "yes");
                    }
                    print("Login");
                  },
                  child: Text("Google_Sign")),
              // ElevatedButton(onPressed: () async {
              //
              //   await GoogleSignIn().signOut();
              //   print("Logut");
              // }, child: Text("Google_Signout")),
            ],
          ),
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

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



  Future createUser(UserModal userModal) async {
    final firestore =
        FirebaseFirestore.instance.collection("user").doc("${userModal.uId}");

    await firestore.set(userModal.toJson());
  }
}
