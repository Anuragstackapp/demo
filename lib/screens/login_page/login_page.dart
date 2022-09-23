import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/common/constant/string_const.dart';
import 'package:demo/service/sharedpreferences_service.dart';
import 'package:demo/model/usermodel/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_sign_in/google_sign_in.dart';


import '../reste_password_page/reste_password_page.dart';


class Loginscrren extends StatefulWidget {
  TabController tabController;

  Loginscrren(this.tabController);

  @override
  State<Loginscrren> createState() => _LoginscrrenState();
}

class _LoginscrrenState extends State<Loginscrren> {
  TextEditingController temail = TextEditingController();
  TextEditingController tpassword = TextEditingController();
  bool chack = false;
  bool _isObscure = true;
  String _character = "User";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              // email
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: temail,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: StringResources.emailLabelText,
                    hintText: StringResources.emailHintText,
                  ),
                ),
              ),
              //password
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: tpassword,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: StringResources.passwordLabelText,
                    hintText: StringResources.passwordHintText,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                      icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),
              ),
              //Admin / User

              Row(
                children: [

                  SizedBox(width: 80),
                  Radio(
                    value: StringResources.userType1,
                    groupValue: _character,
                    onChanged: (value) {
                      setState(() {
                        _character = value.toString();
                      });
                    },
                  ),
                  Text("Admin"),
                  Radio(
                    value: StringResources.userType2,
                    groupValue: _character,
                    onChanged: (value) {
                      setState(() {
                        _character = value.toString();
                      });
                    },
                  ),
                  Text("User"),
                ],
              ),
              //forget password
              TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return restPassword();
                      },
                    ));
                  },
                  child: Text("forgot password")),
              // login button
              ElevatedButton(
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();


                    bool emailValid = RegExp(StringResources.emailRegExp).hasMatch(temail.text);

                    // bool emailValid = RegExp(
                    //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    //     .hasMatch(temail.text);

                    // String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    // RegExp regExp = new RegExp(p);

                    if (emailValid == false && tpassword.text.length < 8) {
                      String errorA = "email and password not vaild";
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(errorA),
                          action: SnackBarAction(
                            label: 'Action',
                            onPressed: () {},
                          ),
                        ),
                      );
                    } else if (emailValid == false) {
                      String errorB = "email is Not Vaild!";
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(errorB),
                          action: SnackBarAction(
                            label: 'Action',
                            onPressed: () {},
                          ),
                        ),
                      );
                    } else if (tpassword.text.length < 8) {
                      String errorC = "Minum 8 lettor in Password";
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(errorC),
                          action: SnackBarAction(
                            label: 'Action',
                            onPressed: () {},
                          ),
                        ),
                      );
                    } else {

                      String waiting = "Loding..";
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(waiting),
                          action: SnackBarAction(
                            label: 'Action',
                            onPressed: () {},
                          ),
                        ),
                      );
                    }

                    try {
                      final credential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: temail.text,
                        password: tpassword.text,
                      );
                      print(credential);
                      widget.tabController.animateTo(2);

                      setPrefKey("login", "yes");
                      UserModal usermodel = UserModal(
                        email: temail.text,
                        password: tpassword.text,
                        uId: credential.user!.uid,
                        type: _character,
                      );
                      createUsers(usermodel);
                      temail.clear();
                      tpassword.clear();
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        print('The password provided is too weak.');
                      } else if (e.code == 'email-already-in-use') {
                        print('The account already exists for that email.');
                        try {
                          final UserCredential credential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: temail.text, password: tpassword.text);
                           
                          final DocumentReference check = FirebaseFirestore.instance.collection("user").doc(credential.user!.uid);
                          print("Document ${check}");
                         return;
                          UserModal usermodel = UserModal(
                              email: temail.text,
                              password: tpassword.text,
                              uId: credential.user!.uid,
                              type: _character,
                          );

                          if(check.id != credential.user!.uid){
                            createUsers(usermodel);
                          }


                          setPrefKey("login", "yes");

                          temail.clear();
                          tpassword.clear();
                          widget.tabController.animateTo(2);
                          print(credential);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            print('No user found for that email.');
                          } else if (e.code == 'wrong-password') {
                            print('Wrong password provided for that user.');

                            String errorD =
                                "Wrong password provided for that user.";
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(errorD),
                                action: SnackBarAction(
                                  label: 'Action',
                                  onPressed: () {},
                                ),
                              ),
                            );
                          }
                        }
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: const Text("Login")),
              //google login
              GFButton(onPressed: () async {
                FocusManager.instance.primaryFocus?.unfocus();

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
                  widget.tabController.animateTo(2);
                  


                  setPrefKey("login", "yes");
                  // SherdPrefe.prefs = await SharedPreferences.getInstance();
                  // await prefs.setBool('login', true);
                  // await SherdPrefe.prefs!.setString("login", "yes");
                } else {
                  CircularProgressIndicator();
                }
                print("Login");

              },
                text: "Google Sign",
                icon: SvgPicture.asset("assets/icons/google.svg"),
                type: GFButtonType.transparent,
              ),


            ],
          ),
        ),
      ),
    );
  }

  //google sign function
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
}
