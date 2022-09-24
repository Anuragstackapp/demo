import 'package:demo/common/constant/string_const.dart';
import 'package:demo/common/method/methods.dart';
import 'package:demo/screens/signup_page/signup_page.dart';
import 'package:demo/service/auth_service.dart';
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
  bool schack = false;
  bool _isObscure = true;
  String _character = "User";
  int i = 2;

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

                    if (emailValid == false && tpassword.text.length < 8) {
                      String message = "email and password not vaild";
                      showMessage(context, message);

                    } else if (emailValid == false) {
                      String message = "email is Not Vaild!";
                      showMessage(context, message);

                    } else if (tpassword.text.length < 8) {
                      String message = "Minum 8 lettor in Password";
                      showMessage(context, message);

                    } else {

                      String message = "Loding..";
                      showMessage(context, message);

                      setState(() {
                        schack = false;
                      });

                    }
                    AuthService().createUser(temail.text,tpassword.text,widget.tabController,_character,i,context);

                    // AuthService().verifyUser(context,temail.text,tpassword.text,widget.tabController,_character);

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

              TextButton(onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                  return SignupPage(widget.tabController);
                },));
              }, child: Text("New User ? Create Account"))


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


}
