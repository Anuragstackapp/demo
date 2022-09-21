
import 'package:demo/pages/splacescrrenpage/splaceScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

  );
  runApp(const MaterialApp(

    home: SplaceScreen(),
    debugShowCheckedModeBanner: false,
  ));
}





