import 'package:demo/service/dataRead.dart';
import 'package:demo/tab_page/Loginscrren.dart';
import 'package:demo/tab_page/Userpage.dart';
import 'package:demo/tab_page/adminPage.dart';
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
          bottom: PreferredSize(
            preferredSize: Size(00,55.0),
            child: IgnorePointer(
              ignoring: true,
              child: TabBar(

                controller: widget.tabController,
                tabs: [
                  Tab(
                      child:  Row(
                        children: [
                          SizedBox(
                            height: 20,
                            width: 30,
                            child: Icon(
                              Icons.login,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.00),
                            child: SizedBox(
                                height: 20,
                                width: 40,
                                child: Text("Login",
                                    style: TextStyle(color: Colors.white))),
                          ),
                        ],
                      )
                  ),
                  Tab(
                      child:  Row(
                        children: [
                          SizedBox(
                            height: 20,
                            width: 30,
                            child: Icon(
                              Icons.supervised_user_circle_sharp,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.00),
                            child: SizedBox(
                                height: 20,
                                width: 40,
                                child: Text("Users",
                                    style: TextStyle(color: Colors.white))),
                          ),
                        ],
                      )
                  ),
                  Tab(
                      child:  Row(
                        children: [
                          SizedBox(
                            height: 20,
                            width: 30,
                            child: Icon(
                              Icons.supervised_user_circle_outlined,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.00),
                            child: SizedBox(
                                height: 20,
                                width: 40,
                                child: Text("User",
                                    style: TextStyle(color: Colors.white,)
                                )),
                          ),
                        ],
                      )
                  ),

                ],
              ),
            ),
          ),
        ),

        body:  TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: widget.tabController,
            children: [
              Loginscrren(widget.tabController,),
              Userpage(widget.tabController),
              adminPage(widget.tabController),


        ]),

      ),
    );
  }
}

