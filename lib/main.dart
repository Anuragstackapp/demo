
import 'package:demo/common/constants/color_as.dart';
import 'package:demo/pages/splacescrrenpage/splaceScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

  );
  runApp( MaterialApp(

    home: SplaceScreen(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(

      appBarTheme: AppBarTheme(
        color: ColorRsourse.splacesccrn,
      ),
    ),
  ));
}





