import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/screens/add_post.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/global_variables.dart';
import 'package:provider/provider.dart';
import 'package:instagram/models/user.dart' as model;

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Color getActiveButtonState(int targetIndex) {
    if (_page == targetIndex) {
      return primaryColor;
    }
    return secondaryColor;
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    print("page: $page");
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    //https://boilerplate.tistory.com/41
    //provider.of를 이용해 provider 객체 가져오기.
    model.User? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: PageView(
        children: homeScreenItems,
        controller: pageController,
        onPageChanged: onPageChanged,
        physics:
            const NeverScrollableScrollPhysics(), //스크롤 통해서 사용자가 옆으로 넘기지 못하게 한다.
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: getActiveButtonState(0)),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: getActiveButtonState(1)),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, color: getActiveButtonState(2)),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: getActiveButtonState(3)),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: getActiveButtonState(4)),
            label: '',
            backgroundColor: primaryColor,
          ),
        ],
        onTap: (value) => navigationTapped(value),
      ),
    );
  }
}
