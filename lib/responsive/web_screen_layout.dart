import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/global_variables.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
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
    setState(() {
      _page = page;
    });
  }

  void onPageChanged(int page) {
    print("page: $page");
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'ic_instagram.svg',
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.home, color: getActiveButtonState(0)),
            onPressed: () => navigationTapped(0),
          ),
          IconButton(
            icon: Icon(Icons.search, color: getActiveButtonState(1)),
            onPressed: () => navigationTapped(1),
          ),
          IconButton(
            icon: Icon(Icons.add_a_photo, color: getActiveButtonState(2)),
            onPressed: () => navigationTapped(2),
          ),
          IconButton(
            icon: Icon(Icons.favorite, color: getActiveButtonState(3)),
            onPressed: () => navigationTapped(3),
          ),
          IconButton(
            icon: Icon(Icons.person, color: getActiveButtonState(4)),
            onPressed: () => navigationTapped(4),
          ),
        ],
      ),
      body: PageView(
        children: homeScreenItems,
        controller: pageController,
        onPageChanged: onPageChanged,
        physics:
            const NeverScrollableScrollPhysics(), //스크롤 통해서 사용자가 옆으로 넘기지 못하게 한다.
      ),
    );
  }
}
