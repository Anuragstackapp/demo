import 'package:demo/tab_page/Loginscrren.dart';
import 'package:demo/tab_page/Userpage.dart';
import 'package:flutter/material.dart';

class Firstpage extends StatefulWidget {
  const Firstpage({Key? key}) : super(key: key);

  @override
  State<Firstpage> createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage> with SingleTickerProviderStateMixin{

  int curentindex = 0;
  late TabController tabController;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title:  Text("Task_Auth"),
          bottom: TabBar(
            controller: tabController,
            tabs: [
              Tab(icon: Icon(Icons.login), text: "Login"),
              Tab(icon: Icon(Icons.man_outlined), text: "User")
            ],
          ),
        ),

        body:  TabBarView(
            controller: tabController,
            children: [
              Loginscrren(tabController,),
              Userpage(tabController),



        ]),

      ),
    );
  }
}

