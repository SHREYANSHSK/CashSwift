import 'package:CashSwift/profile_Page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';

import 'category_Page.dart';
import 'home_Page.dart';

class navBar extends StatefulWidget {
  const navBar({super.key});

  @override
  State<navBar> createState() => _navBarState();
}

class _navBarState extends State<navBar> {
  int myIndex=0;
  List<Widget> widgetList= [
    home_Page(PHONE_NUMBER: GetStorage().read("PHONE_NUMBER"),),
    categoryPage(PHONE_NUMBER:GetStorage().read("PHONE_NUMBER")),
    profilePage(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color.fromRGBO(10, 10, 10, 1),
      body: Center(child: widgetList[myIndex],),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){setState(() {
          myIndex=index;
        });
        },

        elevation: 0,iconSize: 30,
        unselectedItemColor: Colors.white60,
        selectedItemColor: Colors.white,
        currentIndex: myIndex,
        backgroundColor: const Color.fromRGBO(10, 10, 10, 1),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home,),label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.category_sharp),label: "Category"),
          BottomNavigationBarItem(icon: Icon(Icons.person,),label: "Profile")

        ],
      ),
    );
  }
}
