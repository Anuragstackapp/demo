import 'package:demo/common/constant/image_const.dart';
import 'package:demo/service/sharedpreferences_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/constant/color_const.dart';
import '../first_page/first_page.dart';


class SplaceScreen extends StatefulWidget {
  const SplaceScreen({Key? key}) : super(key: key);

  @override
  State<SplaceScreen> createState() => _SplaceScreenState();
}

class _SplaceScreenState extends State<SplaceScreen> with SingleTickerProviderStateMixin{



  late TabController tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    abc();
    tabController = new TabController(vsync: this, length: 3);

  }

  Future abc() async {
   await Future.delayed(Duration(seconds: 4));
   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
     return Firstpage(tabController);

   },));

   if(await checkPrefKey("login")){
     tabController.animateTo(2);
   }
   else{
     tabController.animateTo(0);
   }

  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: Container(
            height: double.infinity,
            width: double.infinity,
            color: ColorRsourse.splacesccrn,
            child: Center(child: Lottie.asset(ImageResources.splaceLogo))),
      ),
    );
  }
}
