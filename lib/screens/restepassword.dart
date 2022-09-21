import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class restPassword extends StatefulWidget {
  const restPassword({Key? key}) : super(key: key);

  @override
  State<restPassword> createState() => _restPasswordState();
}

class _restPasswordState extends State<restPassword> {
  String? email;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("reset password")),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(

              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'email',
                hintText: 'Enter Your email',
              ),
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
          ),
          ElevatedButton(onPressed: () {
            auth.sendPasswordResetEmail(email: email!);
            Navigator.pop(context);
          }, child: Text("Send Request"))
        ]),
      ),
    );
  }
}
