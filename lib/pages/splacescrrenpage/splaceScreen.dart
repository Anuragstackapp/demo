
import 'package:demo/pages/firstpage/Firstpage.dart';
import 'package:demo/model/sherdprefrnce/sprfrnce.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
   await Future.delayed(Duration(seconds: 3));
   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
     return Firstpage(tabController);

   },));
   SherdPrefe.prefs = await SharedPreferences.getInstance();
   if(SherdPrefe.prefs!.containsKey("login")){
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
        body: Center(child: Text("Loding...")),
      ),
    );
  }
}
