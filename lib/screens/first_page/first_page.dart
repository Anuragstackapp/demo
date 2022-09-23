import 'package:demo/common/constant/string_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../common/constant/color_const.dart';
import '../admin_page/admin_page.dart';
import '../login_page/login_page.dart';
import '../users_page/user_page.dart';

class Firstpage extends StatefulWidget {
  TabController tabController;
  Firstpage(this.tabController);



  @override
  State<Firstpage> createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage> with SingleTickerProviderStateMixin{



  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(

        systemOverlayStyle: SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: ColorRsourse.splacesccrn),
        title:  Text(StringResources.appbarTitle),

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
                                child: Text(StringResources.tabbar1,
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
                                child: Text(StringResources.tabbar2,
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
                                child: Text(StringResources.tabbar3,
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

