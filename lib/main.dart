import 'package:demo/screens/splash_screen_page/splash_screen_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'common/constant/color_const.dart';



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





