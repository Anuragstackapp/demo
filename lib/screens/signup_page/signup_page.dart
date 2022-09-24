import 'package:demo/common/method/methods.dart';
import 'package:demo/screens/first_page/first_page.dart';
import 'package:demo/screens/login_page/login_page.dart';
import 'package:demo/service/auth_service.dart';
import 'package:flutter/material.dart';

import '../../common/constant/string_const.dart';

class SignupPage extends StatefulWidget {
  TabController tabController;
  SignupPage(this.tabController);



  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String _character = "User";
  TextEditingController temail = TextEditingController();
  TextEditingController tpassword = TextEditingController();
  TextEditingController tphone = TextEditingController();
  int i = 0;
  bool status = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //signup logo
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("Create Account",style: TextStyle(fontSize: 40,color: Colors.black,fontWeight: FontWeight.bold),),
              ),
              //email
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
              // password
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: tpassword,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: StringResources.passwordLabelText,
                    hintText: StringResources.passwordHintText,
                  ),
                ),
              ),
              // phone
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: tphone,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'phone',
                    hintText: 'Enter Youre Phone number',
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

              //Waiting Messge




              //signup_button

              ElevatedButton(onPressed: () {

                AuthService().createUser(temail.text, tpassword.text, widget.tabController, _character,i,context).then((value) {

                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return Firstpage(widget.tabController);
                  },));
                },);

                showMessage(context, "Waiting");
              }, child: Text("create account"))

            ],
          ),
        ),
      ),
    );
  }
}
