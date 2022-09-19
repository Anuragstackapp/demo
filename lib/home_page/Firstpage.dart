import 'package:demo/tab_page/Loginscrren.dart';
import 'package:demo/tab_page/Userpage.dart';
import 'package:flutter/material.dart';

class Firstpage extends StatefulWidget {
  TabController tabController;
  Firstpage(this.tabController);



  @override
  State<Firstpage> createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage> with SingleTickerProviderStateMixin{

  int curentindex = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  // @override
  // void dispose() {
  //   widget.tabController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title:  Text("Task_Auth"),
          bottom: TabBar(
            controller: widget.tabController,
            tabs: [
              Tab(icon: Icon(Icons.login), text: "Login"),
              Tab(icon: Icon(Icons.man_outlined), text: "User")
            ],
          ),
        ),

        body:  TabBarView(
            controller: widget.tabController,
            children: [
              Loginscrren(widget.tabController,),
              Userpage(widget.tabController),

        ]),

      ),
    );
  }
}

